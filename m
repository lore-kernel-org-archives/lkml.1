Return-Path: <linux-kernel-owner+w=401wt.eu-S1763327AbXIMGds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763327AbXIMGds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 02:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXIMGdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 02:33:41 -0400
Received: from ozlabs.org ([203.10.76.45]:38821 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480AbXIMGdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 02:33:40 -0400
Subject: Re: [PATCH] Add macros for acessing lguest fields
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rostedt@goodmiss.org, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com
In-Reply-To: <11894484404160-git-send-email-gcosta@redhat.com>
References: <11894484404160-git-send-email-gcosta@redhat.com>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 16:32:53 +1000
Message-Id: <1189665173.32322.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-10 at 15:20 -0300, Glauber de Oliveira Costa wrote:
> The assumption that we have an overall irqs_pending flags,
> and a one-to-one lguest <-> task mapping fails to hold on x86_64,
> where we can have multiple puppies, aka vcpus.
> 
> Although ifdefs could be used, it makes the code much more
> unreadable, and other ports are on the way, anyway. So some sort
> of acessor is preferred anyway.

I'd prefer to see the i386 code use vcpus too.  Even if i386 only has
one at present, it's cleaner.

Of course, there'll be a lot of "s/lg/vcpu/" churn, but that's OK.

Thanks,
Rusty.



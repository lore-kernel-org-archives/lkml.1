Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbXLYXy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbXLYXy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXLYXyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:54:51 -0500
Received: from ozlabs.org ([203.10.76.45]:38643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXLYXyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:54:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 0/16] lguest: introduce vcpu structure
Date: Wed, 26 Dec 2007 10:54:45 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest@ozlabs.org, glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rostedt@goodmis.org
References: <11981576363806-git-send-email-gcosta@redhat.com>
In-Reply-To: <11981576363806-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712261054.46261.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 00:33:40 Glauber de Oliveira Costa wrote:
> this patch makes room for the vcpu structure in lguest, already used in
> this very same way at lguest64. It's the first part of our plan to
> have lguest and lguest64 unified too.

Hi Glauber!

    These patches look really solid, thanks!  A few minor things, then I'll 
apply them and push them for 2.6.25.

    My only question is whether we should go further and vpu-ify routines like 
lgread and kill_guest, so that we can avoid more "lg" temporary variables...

> When two dogs hang out, you don't have new puppies right in the other day.
> Some time has to be elapsed. They have to grow first. In this same spirit,
> having these patches _do not_ mean smp guests can be launched (yet)
> Much more work is to come, but this is the basic infrastructure.

OK, that made me laugh...

Thanks!
Rusty.


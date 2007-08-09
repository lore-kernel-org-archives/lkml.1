Return-Path: <linux-kernel-owner+w=401wt.eu-S938461AbXHIApp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938461AbXHIApp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762232AbXHIApe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:45:34 -0400
Received: from ozlabs.org ([203.10.76.45]:40849 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761622AbXHIApd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:45:33 -0400
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <200708090224.16328.ak@suse.de>
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <5d6222a80708080749t35c5c0ceo8b3b8f0cce50c666@mail.gmail.com>
	 <1186615137.17470.100.camel@localhost.localdomain>
	 <200708090224.16328.ak@suse.de>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 10:44:55 +1000
Message-Id: <1186620295.17752.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 02:24 +0200, Andi Kleen wrote:
> Not sure what's best. Ok using a normal export is easiest and not
> that big an issue.

Yeah, there's also been talk of breaking up paravirt_ops into multiple
structs by area, which would lead naturally into finer-grained export
control.

Cheers,
Rusty.


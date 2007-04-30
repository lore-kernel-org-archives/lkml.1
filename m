Return-Path: <linux-kernel-owner+w=401wt.eu-S1423004AbXD3FEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423004AbXD3FEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423006AbXD3FEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:04:14 -0400
Received: from ozlabs.org ([203.10.76.45]:46047 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423004AbXD3FEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:04:12 -0400
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
	relocatable bzImage
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <463572B7.90202@zytor.com>
References: <20070428758.455116000@suse.de>
	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
	 <1177902195.30071.203.camel@localhost.localdomain>
	 <463572B7.90202@zytor.com>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 15:03:54 +1000
Message-Id: <1177909434.30071.216.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 21:38 -0700, H. Peter Anvin wrote:
> Rusty Russell wrote:
> > 
> > Dammit, Eric, you spend a lot of time using words like "insane" where
> > you mean we didn't do everything all at once.
> > 
> > It's *not* clear that using %esi is sane, but nothing in the current
> > code prevents that.
> 
> Why not?

(I assume you mean why isn't it clear?)

Because VMI uses the presence of a ROM to indicate it's not native.  KVM
uses a magic MSR IIRC.

I think it makes sense for lguest to change over, tho.  Patches welcome
8)

Rusty.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbXE0AK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbXE0AK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 20:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbXE0AKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 20:10:23 -0400
Received: from ozlabs.org ([203.10.76.45]:39810 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbXE0AKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 20:10:22 -0400
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Wright <chrisw@sous-sol.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4658C72E.9030205@goop.org>
References: <4656FB8F.4090604@goop.org>
	 <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com>
	 <1180174691.650.8.camel@localhost.localdomain>  <4658C72E.9030205@goop.org>
Content-Type: text/plain
Date: Sun, 27 May 2007 10:10:04 +1000
Message-Id: <1180224604.29340.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-27 at 00:47 +0100, Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > You also want to skip the cli: perhaps a separate flag for this is
> > appropriate though.
> >   
> 
> Not a problem for Xen; it will be trapped+emulated (ie, ignored).

Well, I could do that for lguest as a special case, I guess.  Seems icky
tho.

hpa wrote:
> Do we have *any* environment that enters the 32-bit code with interrupts
> enabled?  I would think that is unsafe no matter how you do it.

Yeah, the cli there seems strange: maybe it's safe to simply delete it?

Cheers,
Rusty.


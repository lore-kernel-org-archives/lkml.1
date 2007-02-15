Return-Path: <linux-kernel-owner+w=401wt.eu-S1751154AbXBOAN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbXBOAN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 19:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbXBOAN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 19:13:29 -0500
Received: from gw.goop.org ([64.81.55.164]:60598 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbXBOAN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 19:13:28 -0500
Message-ID: <45D3A5A4.7080804@goop.org>
Date: Wed, 14 Feb 2007 16:13:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>,
       Ian Campbell <Ian.Campbell@XenSource.com>
Subject: Re: [patch 16/21] Xen-paravirt: Add code into head.S to handle being
 booted by Xen
References: <20070213221729.772002682@goop.org>	<20070213221830.707197267@goop.org> <20070213235424.GA1908@muc.de>	<45D35ABE.1050504@goop.org> <m1zm7gpkjh.fsf@ebiederm.dsl.xmission.com>	<45D3740A.4080600@goop.org> <m17iukphxr.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m17iukphxr.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Ok.  If that is all this may be a difference that makes no difference.
> binutils has a bad habit of looking at sections (which are fully
> optional) instead of segments on ET_EXEC and ET_DYN objects.  Only
> ET_REL objects (.o files) are required to have sections.
>   

The Xen domain loader will have to be changed to deal with that, which
isn't too much of a problem.

My main concern is the randomness of it, and whether it will fail in
some more harmful way on other versions of binutils.

> So I recommend for testing write a 100 line program that includes
> elf.h and reads out the note segment.  If all is well we can split
> this code out.
>   

The Xen readnotes utility is essentially that.  I'll hack it.

    J

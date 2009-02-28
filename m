Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZB1Hry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZB1Hry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZB1Hrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:47:45 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:37265 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZB1Hrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:47:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yth5nkxARlPBCi49iYtYw0b1wjuRN3iNpzgJ569POqy/9RGWY3i3UmcAqX1Ryd2J13
         i8zSq7KDstVapJN3yaN+bDRmQ1ZVtgyYyeUoR1m47P3/evoU701QkkHIGCJzRhR7b1T1
         14iA3pcAdmTp1/7+foNpAOG5Wk287QCxXSv8U=
Date: Sat, 28 Feb 2009 10:47:40 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: does boot loader check uncompressed kernel size?
Message-ID: <20090228074740.GA7581@localhost>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu> <49A8EA1A.50802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A8EA1A.50802@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Fri, Feb 27, 2009 at 11:39:06PM -0800]
| wonder if boot loader check uncompress size aka vmlinux size in bzImage
| before it find one good position for bzImage...?
| 
| YH
| 

At least for x86-64 in grub-1.96 I didn't find such a check.
Btw, but why should it care? Or you mean something else?

	- Cyrill -

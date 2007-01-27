Return-Path: <linux-kernel-owner+w=401wt.eu-S1750997AbXA0Ieb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997AbXA0Ieb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbXA0Ieb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:34:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:6866 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbXA0Iea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hWroKW+7coa6r510fjDVlj8AIbHvV6EVyCD6zOAqCRl+tzw6S6rYb0/iBK23NL2ybLoLnTxP5vM3L4lmEuMBuf3hqbaZr0rw3FUF81qWMXRCNEphNteF4i3sLz5AuPCO+x5HbdsbB4rmrknpPvMDENMNdXZYgA4+LiTn4y+a2AU=
Message-ID: <9e0cf0bf0701270034w491ff69dnb6019b4dd30f6d54@mail.gmail.com>
Date: Sat, 27 Jan 2007 10:34:27 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>
Subject: Re: [PATCH 10/26] Dynamic kernel command-line - ia64
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, "Bernhard Walle" <bwalle@suse.de>
In-Reply-To: <20070127002453.57b1e071.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200701230010.34323.alon.barlev@gmail.com>
	 <200701230014.06793.alon.barlev@gmail.com>
	 <20070127002453.57b1e071.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/07, Andrew Morton <akpm@osdl.org> wrote:
> no no no no no no no.  Just because some whacked-out weenie went and put
> extern declarations in .c files doesn't mean that we should copy them.
>
> It doesn't even compile.

Sorry... I don't have all environments.

> Please.  Go through the entire patchset, yank all those wrong private
> declarations of boot_command_line[] and put a *single, kernel-wide*
> declaration into a single, shared header file.

I thought of this, while I was making the patch, I could not understand why
the maintainer did not simply #include <linux/init.h>

I can add this to any module which declares this by-itself but because
I cannot test all arch, I am afraid it will cause more problems.

Preparing a patch... :)

Best Regards,
Alon Bar-Lev.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYJOTu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYJOTu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYJOTuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:50:10 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:61913 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYJOTuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=t6L51ZVW0tI8j/7Q/gET0ZSS2XZwi4UNcqEKl1jhs2tIqo7w7cnK4EgdsPmNy0ssZF
         oqtiHsfQb6frTfkGuUxA7ls/0FF/KU6JHSTRHPXUHv/mkFiuGq7USlICpu+Xh5pv762I
         Ilk+3kafPHUsrU6yv4DYn3yjB80q/qQ+X/k4k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] ide: remove dead <asm-arm/arch-sa1100/ide.h>
Date: Wed, 15 Oct 2008 20:10:48 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <200808101745.20434.bzolnier@gmail.com> <48F4EAC4.4000702@ru.mvista.com>
In-Reply-To: <48F4EAC4.4000702@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810152010.48381.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 October 2008, Sergei Shtylyov wrote:
> Hello.

You're back!! :)

> Bartlomiej Zolnierkiewicz wrote:
> 
> > It has been dead for more than 3 years and needs to be converted
> > to use platform PATA support anyway.
> 
>     This patch in the current pata-2.6 series does not apply at all.

Yeah, Stephen also noticed this while trying to cook new linux-next.

> > Cc: Russell King <rmk@arm.linux.org.uk>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Applying patch ide-remove-dead-asm-arm-arch-sa1100-ide-h.patch
> The text leading up to this was:
> --------------------------
> |From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> |Subject: [PATCH] ide: remove dead <asm-arm/arch-sa1100/ide.h>
> |
> |It has been dead for more than 3 years and needs to be converted
> |to use platform PATA support anyway.
> |
> |Cc: Russell King <rmk@arm.linux.org.uk>
> |Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> |---
> | include/asm-arm/arch-sa1100/ide.h |   75 --------------------------------------

It seems that in the meantime include/asm-arm/arch-sa1100/ide.h
became arch/arm/mach-sa1100/include/mach/ide.h.  Fixed.

> | 1 file changed, 75 deletions(-)
> |
> |Index: b/include/asm-arm/arch-sa1100/ide.h
> |===================================================================
> |--- a/include/asm-arm/arch-sa1100/ide.h
> |+++ /dev/null
> --------------------------
> No file to patch.  Skipping patch.
> 1 out of 1 hunk ignored
> 
> MBR, Sergei

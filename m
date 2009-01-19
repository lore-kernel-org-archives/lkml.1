Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZASOg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZASOg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZASOgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:36:13 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:48567 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZASOgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:36:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=TL2gkxnSyzRbgfzCJrMCrs1HCidVqooNumGJPSV8Xi6rPFCR/SVGYP/UwG8Ov0Sd+/
         gfhqGQ9F7jIiL92lxLep1LLp2ckDs0JzeMc6LAiC9uNzz+x4BGW5ygm3btngujVpXvvW
         53FhfZq/7UwjP8Oa3ZkSPrCK+9mcfZqyZD0wc=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <20090119141443.27613.89085.sendpatchset@localhost.localdomain>
References: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
	 <20090119141443.27613.89085.sendpatchset@localhost.localdomain>
Date: Mon, 19 Jan 2009 15:36:10 +0100
Message-ID: <9ea470500901190636g366767bt2b40917b2d2718f9@mail.gmail.com>
Subject: Re: [PATCH 08/12] ide: remove no longer needed IDE_HFLAG[_FORCE]_LEGACY_IRQS
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 19, 2009 at 3:14 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:

[.. ]

> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -1347,10 +1347,6 @@ enum {
>        IDE_HFLAG_ERROR_STOPS_FIFO      = (1 << 19),
>        /* serialize ports */
>        IDE_HFLAG_SERIALIZE             = (1 << 20),
> -       /* use legacy IRQs */
> -       IDE_HFLAG_LEGACY_IRQS           = (1 << 21),
> -       /* force use of legacy IRQs */
> -       IDE_HFLAG_FORCE_LEGACY_IRQS     = (1 << 22),
>        /* host is TRM290 */
>        IDE_HFLAG_TRM290                = (1 << 23),
>        /* use 32-bit I/O ops */

maybe contigious numbering of the enums here?

-- 
Regards/Gruss,
Boris

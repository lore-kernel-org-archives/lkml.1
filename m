Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYAPKD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYAPKD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 05:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYAPKDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 05:03:21 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:4781 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYAPKDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 05:03:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yv5GCMDdgY8FW5KZrt/TjfvxictogjcRhfS4x9ORxCsSAKUfbDgNTi9Ym/daah/B8WTF4y1wL5SISzkt5afAEH7Q9u0GkWiQESwTxMNrXNWC5bpuqvsQKQ7+veAU39PNPWz3MJqbDN2t5bHpPuvhQqYn7ISZJJ4G5PmI22OZFCo=
Message-ID: <a8e1da0801160203s234f7005k3e95aa8b007c0f70@mail.gmail.com>
Date: Wed, 16 Jan 2008 18:03:17 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Rogier Wolff" <R.E.Wolff@bitwizard.nl>
Subject: Re: mtime updates for mmapped files.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080116094640.GA2071@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080116094640.GA2071@bitwizard.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 5:46 PM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
>
> Hi,
>
> I  wrote a small app yesterday that updates a file by mmapping the
> file (RW), changing the thing around, and then exiting.
>
> This did not trigger a change in the mtime of the file. Thus rsync
> didn't pick up that the file had changed.
>
> I understand that tracking every change to a RW mmapped file is
> costly, and thus unfeasable, but shouldn't then the close cause a
> mtime update?
>
> The server where this happened is running 2.6.21, so my apologies if
> this has already been corrected.

This is an old bug, don't know if it was fixed or not. Please see
http://lkml.org/lkml/2006/5/17/138

>
>         Roger.
>
> --
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
> **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
> *-- BitWizard writes Linux device drivers for any device you may have! --*
> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement.
> Does it sit on the couch all day? Is it unemployed? Please be specific!
> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

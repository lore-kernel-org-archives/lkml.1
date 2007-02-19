Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbXBSLmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbXBSLmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbXBSLmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:42:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:36671 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122AbXBSLmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:42:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=i7G4e1Rffx1AAPKAvLRpH3zCMWejVE/Qq/D9erw0fKTpBobdgkmSf56mxz6ahA2k2Ym5LvIIT5UXwCZZCNnSA2PDBrjDQKyKGBP8opxV1rd6RIQdIexr0XW9voYpiE3JxBKHdIIqCNl9PjeMpb+wwfmdxMVT/daopduEUf8aPLo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
Subject: Re: [BUG/WARN] Error initialising drivers in PCI
Date: Mon, 19 Feb 2007 12:47:03 +0100
User-Agent: KMail/1.9.5
Cc: gregkh@suse.de, "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Tejun Heo" <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>
References: <5640c7e00702181153q44678861q9963e7e2de00be8@mail.gmail.com> <200702182158.13429.bzolnier@gmail.com> <5640c7e00702182000p26f1ca8n15c1edcd8b3134a1@mail.gmail.com>
In-Reply-To: <5640c7e00702182000p26f1ca8n15c1edcd8b3134a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702191247.03274.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 19 February 2007 05:00, Ian McDonald wrote:
> On 2/19/07, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > Ian, you have an PATA controller so there is no need to use ata_piix.
> > Just disabling ata_piix should workaround the issue.
> >
> OK. I have done this and the message goes away in boot logs. As you
> say I don't need the old drivers anymore.

No, I said that you don't need the new drivers anymore as the warning
is caused by libata using resource hacks. 8)

Anyway both drivers (old and new) work fine, just mixing them have issues.

> If you want me to test any fixes so both can coexist without throwing
> a warning then just drop me a line.

Tejun, this needs to be fixed unless Jeff pushes resources hack
removal patch(es) before 2.6.21 (then it will fix by itself).

Thanks,
Bart

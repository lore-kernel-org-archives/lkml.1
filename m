Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZAJN1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZAJN1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZAJN1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:27:11 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:48246 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZAJN1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:27:10 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
Date: Sat, 10 Jan 2009 14:27:06 +0100
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>, lkml <linux-kernel@vger.kernel.org>
References: <200901091334.55823.borntraeger@de.ibm.com> <200901101404.39139.borntraeger@de.ibm.com> <49689F19.7030203@garzik.org>
In-Reply-To: <49689F19.7030203@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101427.06645.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 10 Januar 2009 schrieb Jeff Garzik:
> Christian Borntraeger wrote:
> > Am Samstag 10 Januar 2009 schrieb Alan Cox:
> >>>    That's the typical REQUEST SENSE command with 18-byte data length.
> >> Which means something has become horribly broken in the core libata 
stack.
> >> An 18 byte inquiry would have 18 bytes as the *last* sg element. That
> >> would therefore not trigger the WARN_ON. Someone has passed an sg list
> >> that isn't properly terminated perhaps ?
> >>
> >> I wonder if the pad code broke this.
> > 
> > I just checked 2.6.28 + PIO32 patch. Its also broken. Whatever caused this 
> > problem did it a while ago.
> 
> Just to be clear, you mean:
> 
> 2.6.28 is OK
> 2.6.28 + PIO32 is broken
> 
> Correct?

Yes.

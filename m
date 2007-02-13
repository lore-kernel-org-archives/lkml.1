Return-Path: <linux-kernel-owner+w=401wt.eu-S1751436AbXBMSKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbXBMSKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbXBMSKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:10:04 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:60117 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbXBMSKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:10:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bU9WJNUeKEP37NAPNk0abTQFFqlFw9T0btwrFNZlb35BY3dI3wI59LHe7ykGxLX0sEgYHvCNBLNqcdNfPACBJ6G/1KhO0JTVExO3h/5oi0bxNSatR3lRub1M7luh42UNjojOXx3srkAQB6EnsvNohnlHZNoYTKR3QWQdvopxAkI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Joel Soete <soete.joel@scarlet.be>
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
Date: Tue, 13 Feb 2007 19:15:12 +0100
User-Agent: KMail/1.9.5
Cc: Tejun Heo <htejun@gmail.com>, Luming Yu <luming.yu@gmail.com>,
       Alan Cox <alan@redhat.com>, Ioan Ionita <opslynx@gmail.com>,
       Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com> <45D0D133.8070801@scarlet.be> <45D1F6E4.2080102@scarlet.be>
In-Reply-To: <45D1F6E4.2080102@scarlet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702131915.12373.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 13 February 2007 18:35, Joel Soete wrote:

> scsi3 : ata_piix
> ata1.00: ATA-4, max UDMA/66, 29336832 sectors: LBA
> ata1.00: ata1: dev 0 multi count 16
> ata1.00: configured for UDMA/33

<...>

> scsi 3:0:0:0: Direct-Access     ATA      QUANTUM FIREBALL A03. PQ: 0 ANSI: 5

IDE driver with CONFIG_IDEDMA_IVB=y should give you UDMA/66.

Could you send me output of "hdparm --Istdout /dev/sdc" command?

> scsi4 : ata_piix
> ata2.01: ATAPI, max MWDMA1
> ata2.01: configured for MWDMA1

and "hdparm --Istdout /dev/sr0"

[ max speed == MWDMA1 is possible but quite unusual ]

Thanks,
Bart

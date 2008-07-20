Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYGTUNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYGTUNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 16:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYGTUNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 16:13:42 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:25317
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbYGTUNl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 16:13:41 -0400
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2008 16:13:41 EDT
X-Trace: 113580797/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYEANg2g0jDlSwG/2dsb2JhbACBWqtf
X-IronPort-AV: E=Sophos;i="4.31,219,1215385200"; 
   d="scan'208";a="113580797"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Simen Timian Thoresen <simentt@dolphinics.no>
Subject: Re: Misidentification and failing revalidations of ide dvd-roms with libata
Date: Sun, 20 Jul 2008 21:03:51 +0100
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <48838593.8020007@dolphinics.no> <20080720194628.6c8632cb@the-village.bc.nu> <48839358.8010206@dolphinics.no>
In-Reply-To: <48839358.8010206@dolphinics.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807202103.51889.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 July 2008 20:34:48 Simen Timian Thoresen wrote:
> Alan Cox wrote:
> >> [  155.457098] ata4.00: model number mismatch 'Pioneer DVD-ROM
> >> ATAPIModel DVD-116  0109' != 'Pioïeer¡DVD­ROM¡ATAñIMoåel åVD-±16 ¡010¹'
> >> [  155.457103] ata4.00: revalidation failed (errno=-19)
> >
> > So it failed because the data read from the drive was corrupted.
> >
> >> As I understand, this would most commonly indicate that the drive has
> >> gone bad, but this also occurs on the /other/ drive (same make/model) in
> >
> > Or a cable problem.
>
> Hi Alan,
>
> Should this apply here too? There are two separate cables, and I've
> never seen the other drive to fail after the first drive has failed.
> I've now ripped ~50 CDs with the still working drive, while this drive
> failed during the first 5 CDs on my two previous boots.
>
> I don't doubt that the revalidation goes bad, but I can't see hardware
> being the cause of it as it hits any drive, but so-far only one drive pr
> boot.

Power supply maybe? Check the rails. The +12VDC must be good.

-- 
Cheers,
Alistair.

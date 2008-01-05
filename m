Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbYAFFkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbYAFFkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 00:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYAFFkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 00:40:05 -0500
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:35639 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750951AbYAFFkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 00:40:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=6p2pPilYdYzGgt81K5dRYQBeoxUCRXb06Nr3Bvhsqyv2x7xdmJPRQD5mQJTXGUNL50eFfSz2JSWcANtA7o9qqzFLNANh7ugxoGg8JulMGq/40H3S5PAb/IDih6ahM8h97jiaNwzxlKLKhlnEoyEbRLyjqzgyStn+cnxmQvSHUgs=  ;
X-YMail-OSG: 5ifEnUwVM1nSpE_Bjp9Wj3jeXyV9WvGmLhOTlQCh9yzG6yGJJSwGCjbIvJRvPvCplyfPvjX7uA--
Date: Sat, 5 Jan 2008 22:45:19 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 06/10] ide-floppy: report DMA handling in
	idefloppy_pc_intr() properly
Message-ID: <20080105214519.GA4470@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-6-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-7-git-send-email-bbpetkov@yahoo.de> <200801051646.05131.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801051646.05131.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 04:46:05PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Hmm, no.  The driver is called ide-floppy (ide_floppy) and it is more
> readable this way.
> 
> >  {
> >  	idefloppy_t *floppy = drive->driver_data;
> >  	struct gendisk *g = floppy->disk;
> > @@ -1479,7 +1450,7 @@ static ide_proc_entry_t idefloppy_proc[] = {
> >  };
> >  #endif	/* CONFIG_IDE_PROC_FS */
> >  
> > -static int ide_floppy_probe(ide_drive_t *);
> > +static int idefloppy_probe(ide_drive_t *);
> 
> ditto
>  
> [...]
> 
> > @@ -1733,7 +1704,7 @@ static struct block_device_operations idefloppy_ops = {
> >  	.revalidate_disk= idefloppy_revalidate_disk
> >  };
> >  
> > -static int ide_floppy_probe(ide_drive_t *drive)
> > +static int idefloppy_probe(ide_drive_t *drive)
> 
> ditto
Shouldn't those also conform to the driver function format idefloppy_bla() -
after all, those function names are unambiguous for the whole file...?

-- 
Regards/Gruﬂ,
    Boris.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZAFRPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZAFRPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZAFROz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:14:55 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:45705 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZAFROy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:14:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=G+YX5td5lWONiwCqQPKdy2GiKzBBZomFiyKPb+VJ6jgIDoOPH9KHyVd62iL9Qf/BoC
         imfozeyR1ol8OzXko2AWwKuFYRxXL86eqCGO0VxWVd7+33ffrgU49LlBwIWxWKp5yKuJ
         6aANgsGX+OhCJq47syHc70iY6BcMAI3zmJ5/s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] ide: can't use SSD/non-rotational queue flag for all CFA devices
Date: Tue, 6 Jan 2009 18:04:15 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.i686; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200901051951.29692.bzolnier@gmail.com> <496279B6.5080802@ru.mvista.com>
In-Reply-To: <496279B6.5080802@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901061804.15343.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > Some rotating disks also present themselves as CFA devices.
> >
> > Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >   
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> > Index: b/drivers/ide/ide-disk.c
> > ===================================================================
> > --- a/drivers/ide/ide-disk.c
> > +++ b/drivers/ide/ide-disk.c
> > @@ -633,7 +633,7 @@ static void ide_disk_setup(ide_drive_t *
> >  	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name,
> >  		q->max_sectors / 2);
> >  
> > -	if (ata_id_is_ssd(id) || ata_id_is_cfa(id))
> > +	if (ata_id_is_ssd(id))
> >  		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
> >  
> >  	/* calculate drive capacity, and select LBA if possible */
> > N‹§²æìr¸›yúèšØb²X¬¶Ç§vØ^–)Þº{.nÇ+‰·¥Š{±‰×¢žØ^n‡r¡ö¦zË�ëh™¨è­Ú&¢ø®G«�éh®(­éšŽŠÝ¢j"�ú¶m§ÿï�êäz¹Þ–Šàþf£¢·hšˆ§~ˆmml==
> 
> Hm, why your Kmail base64-encodes plain English messages and adds this 
> kind of binary crap?

Huh?  Haven't you heard about the latest trend of inserting hidden data
into your mails?  All the cool dudes are doing it nowadays... 8-)

Now seriously... I would love to know the answer to your question myself.

[ After distro upgrade I noticed that new KMail's version started adding
  a non-ascii character at the end of inserted file (when composing message
  and using "Message" -> "Insert File").  The workaround is to remove the
  character manually but I sometimes forget about it... ]

Thanks,
Bart

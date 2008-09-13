Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbYIMXZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbYIMXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 19:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYIMXZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 19:25:47 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:50256 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbYIMXZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 19:25:46 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: 7eggert@gmx.de
Subject: Re: Partition check considered as error is breaking mounting in 2.6.27
Date: Sat, 13 Sep 2008 20:25:39 -0300
User-Agent: KMail/1.9.10
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, bogdano@mandriva.com.br,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Abdel Benamrouche <draconux@gmail.com>,
       Damien Lallement <dlallement@mandriva.com>,
       "pterjan@mandriva.com" <pterjan@mandriva.com>,
       Jens Axboe <axboe@kernel.dk>
References: <bblSy-60j-19@gated-at.bofh.it> <bbnhC-7Vd-5@gated-at.bofh.it> <E1KeRMh-0001Ay-Uj@be1.7eggert.dyndns.org>
In-Reply-To: <E1KeRMh-0001Ay-Uj@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809132025.40300.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 September 2008 06:24:27 Bodo Eggert wrote:
> Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> 
> > +++ b/fs/partitions/check.c
> > @@ -499,9 +499,9 @@ int rescan_partitions(struct gendisk *disk, struct
> > block_device *bdev)
> >  if (!size)
> >  continue;
> >  if (from + size > get_capacity(disk)) {
> > -                     printk(KERN_ERR " %s: p%d exceeds device capacity\n",
> > +                     printk(KERN_WARNING
> > +                             " %s: p%d exceeds device capacity"
>                                 ", trimmed\n",
> >  disk->disk_name, p);
> 
> Add "size = get_capacity(disk) - from" here?
> (Possibly using a cached value for get_capacity(disk)?)

Trim was already proposed here before (not accepted):
http://lkml.org/lkml/2006/10/12/364

--
[]'s
Herton

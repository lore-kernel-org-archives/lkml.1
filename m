Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbXBRS37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbXBRS37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 13:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXBRS37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 13:29:59 -0500
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:32992 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831AbXBRS36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 13:29:58 -0500
Date: Sun, 18 Feb 2007 19:27:23 +0100
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: stern@rowland.harvard.edu, dougg@torque.net
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       James.Bottomley@steeleye.com
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
Message-ID: <45d89a8b.QpxTpRwQB4A12sQN%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0702181124450.6341-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0702181124450.6341-100000@netrider.rowland.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> wrote:

> > Alternatively the SG_GET_RESERVED_SIZE ioctl could be
> > modified to yield no more than max_sectors*512 .
>
> There should be one single ioctl which can be applied uniformly to all
> CD-type devices (in fact, to all devices using a request_queue) to learn
> max_sectors.  This rules out using SG_GET_RESERVED_SIZE.

This has nothing to do with CD-type devices!
It is related to SCSI tansport.

> Furthermore, if you changed SG_GET_RESERVED_SIZE in this way you would 
> only increase the confusion.  The reserved size isn't directly related to 
> the maximum allowed DMA length, and there's no point pretending it is.  
> What if it turns out that the reserved size is smaller than max_sectors?  
> Then you'd force user programs to do I/O in chunks that were smaller than 
> necessary.

It would not increase confusion but reduce confusion because all
programs would later behave correctly without the need to change them.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily

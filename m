Return-Path: <linux-kernel-owner+w=401wt.eu-S932851AbXBVBBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbXBVBBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932890AbXBVBBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:01:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:32605 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851AbXBVBBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nQnfHgomkhGiEgbyvJdeXAUZRDvJA7h1O4ayoGEwJrBeZ80yhahN2xMI+zFURO5q21uhyWQ5tIEpbxfonHqSrdv77uzgdBPzV09bMM96TdzlX51ya8p3pVzMGUqerV6hBeEBWa1NjelfDavM3JN9NFRhig9q//doOlJoyrGWJnY=
Message-ID: <e5ab0f710702211701u4c5b62c5jb560f166641512ff@mail.gmail.com>
Date: Thu, 22 Feb 2007 01:01:43 +0000
From: "Francesco Pretto" <ceztko@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
In-Reply-To: <20070221235541.35f3d0da@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e5ab0f710702211415p37444279td690c2db4b4ca8ab@mail.gmail.com>
	 <20070221235541.35f3d0da@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm sorry if the thread breaks, i'm not subscribed)

2007/2/21, Alan <alan@lxorguk.ukuu.org.uk>:
> Stick some printk calls in drivers/ata/libata-eh.c in ata_eh_suspend, or
> turn on all the ATA debug and shutdown, the code should issue a cache
> flush followed by a standbynow1 command for each disk.
>
> Alan
>

Hi! Using netconsole, i was able to capture some printk output.
Following some advices in the net (forum threads about similar
problems), i did this to enable more verbose printk printing:

echo 8 > /proc/sys/kernel/printk
echo 1 > /proc/sys/vm/block_dump

This was the result:
http://bugzilla.kernel.org/attachment.cgi?id=10492&action=view

However, i'm not still sure i enabled as much debugging info as i
could in the kernel configuration. If you need more, please point me
to precise configuration options.

Thanks for your response.

Francesco Pretto

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYLONzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYLONzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYLONzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 08:55:33 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:36459 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYLONzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 08:55:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NPhdLUmZzohjsNzTHDagSk/PiuJpVPH+tCjFJITHhh+n1c7xzZdJUqp+Nhl1i872kw
         Wlwd0A8bye4W6u3A+G2ZZV56QGW60nbDIFpHhMGezQfZSCQJT73Tvcl/e+S5VocTw29W
         dk8oMPi9U4RGxXNW8VJI6n+cnHZLxi4M0zcbA=
Message-ID: <14cd75110812150555m36e1fef8w8f966b9acdd336@mail.gmail.com>
Date: Mon, 15 Dec 2008 18:55:31 +0500
From: "Muhammad Mutahir Latif" <mutahirlatif@gmail.com>
Reply-To: mutahirlatif@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Re: SATA passthrough commands from User Space
In-Reply-To: <4940CFB3.8030005@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <14cd75110812110005n2809dae7n909a606f68ff1a61@mail.gmail.com>
	 <4940CFB3.8030005@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Jeff for the SG_IO suggestion. Are there any numbers as to
the average throughput achieved using the SG_IO ioctl. The reason I am
asking is that for our scenario the data transfer throughput required
might not be fulfilled using the SG_IO ioctl due to the SCSI->ATA
translations. In case the SG_IO does not fulfill the requirement,
where should we add IOCTL functionality. At first I was thinking of
adding it to the AHCI driver, but by looking at the code I saw that
the ahci driver only implements functions so that they can be hooked
with the libata framework, so  should I add IOCTL hooks to the
libata?. Please let me know if I am by any chance going completely in
the wrong direction.

Thanks

Mutahir

On Thu, Dec 11, 2008 at 1:30 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Muhammad Mutahir Latif wrote:
>>
>> Hi
>>
>> I am new to linux kernel development and need help in developing an
>> application in linux for a SATA device. What is required is that the
>> application needs to send raw SATA commands along with data (like Read
>> DMA, Write FPDMA etc) to a SATA hard disk. Secondly we also have to
>> achieve a reasonably high data transfer throughput.
>
> Use the existing SG_IO ioctl.
>
>        Jeff
>
>
>
>

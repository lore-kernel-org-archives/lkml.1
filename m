Return-Path: <linux-kernel-owner+w=401wt.eu-S932882AbXBXPSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbXBXPSD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 10:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbXBXPSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 10:18:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:16956 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882AbXBXPSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 10:18:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kna74/9QzyWKt4pZKMKhG71xyueeWnb9Rv2dqJNWOPeIFOr8GdxJM6jw1ZWz2TRX4rBo/JhbpVheKG0XG1EPB9/vNJ1wYHkRUptHMNW/heCy1hqH6htOYCdshseG2kMPWEDZWkKjMB1UmKP/OGjjAUebwJIzEigUsNYY5JdSNfY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Patrick Ale" <patrick.ale@gmail.com>
Subject: Re: [QUESTION] Sata RAID
Date: Sat, 24 Feb 2007 16:24:16 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <8d158e1f0702240210x71f981a6xf2fe8917dac5e91a@mail.gmail.com>
In-Reply-To: <8d158e1f0702240210x71f981a6xf2fe8917dac5e91a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702241624.17024.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


use device mapper and dmraid

	http://people.redhat.com/~heinzm/sw/dmraid/

and please read

	http://linux-ata.org/faq-sata-raid.html

On Saturday 24 February 2007, Patrick Ale wrote:
> Hi,
> 
> Quick question,
> 
> Since I am going to open my server today to do some pata tests (for
> the weird detection problems people are giving me fantastic help with,
> no sarcasm, I really mean it) I thought: why not add two 320GB SATA
> disks on the SATA controller that the mainboard has.
> 
> I am wondering: should I use the onboard RAID function? Is this
> supported by Linux? I remember back in "the old days (TM)" there were
> seperate (spelling) drivers for ataraid, how does the current 2.6
> branch cope with the RAID functions of modern motherboards?
> 
> I am aware that it is NOT hardware raid, the raid is done in the
> driver, which is why you need this fancy boot disk before installing
> Windows on your RAID set.
> 
> Or would you suggest me to stick with MD devices?
> 
> 
> Cheers,
> 
> Patrick Ale
> patrick.ale@gmail.com
> 
> "kun kasvan isoksi, halun olla poro"

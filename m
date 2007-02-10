Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbXBJGta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbXBJGta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 01:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXBJGt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 01:49:29 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:25081 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbXBJGt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 01:49:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=TCVWDbskJ56/kJQaourPDR1qXIspPK/sT1mVJcZ+m2VbECcCqnABPPiYiodze7XvnMScjME/97bj09BjRjcNQL+kc2cSHDHuQrxachFOa3/6lxJDLKh9DQLcVPXjPiLuQ6dzWbrUs+C9wyYxuTMnes3mDpjxTLUvb56yt/NOd7k=
Message-ID: <45CD6AE2.4040409@gmail.com>
Date: Sat, 10 Feb 2007 01:49:06 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Emmeran Seehuber <rototor@rototor.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.18.2: sporadic SATA port resets (Broadcom BCM5785 (HT1000))
References: <200702071817.17006.rototor@rototor.de> <200702091237.24576.rototor@rototor.de> <45CC7D04.5090403@gmail.com> <200702091809.19418.rototor@rototor.de>
In-Reply-To: <200702091809.19418.rototor@rototor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Emmeran Seehuber wrote:
> # smartctl -a /dev/sda
> smartctl version 5.36 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce 
> Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> Device: ATA      WDC WD1500ADFD-0 Version: 20.0
> Serial number:      WD-WMAP41246348
> Device type: disk
> Local Time is: Fri Feb  9 18:06:23 2007 CET
> Device does not support SMART

Hmmm... Raptor not supporting SMART.  That's weird.  Please try 
'smartctl -d ata -a /dev/sda'.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbXBKWUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbXBKWUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932580AbXBKWUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:20:12 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:5797 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbXBKWUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:20:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=oo3FhXiY/GwVNT8LzidnnUJEw5OGjr2zRGgCxP1bUlFbBOmC+Rpllaka0pIjxAD2C2omg+FQ8zAd/qoKdQOFTpefR6Mco+drv16MuSVpFZH1ZGSVH4LOlnu50eYFhYAbOHpIEv3aWertghk/dLhRKd9pRtSorQSJoPBLC72itBQ=
Message-ID: <45CF967E.4030306@gmail.com>
Date: Sun, 11 Feb 2007 17:19:42 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Emmeran Seehuber <rototor@rototor.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.18.2: sporadic SATA port resets (Broadcom BCM5785 (HT1000))
References: <200702071817.17006.rototor@rototor.de> <200702091809.19418.rototor@rototor.de> <45CD6AE2.4040409@gmail.com> <200702100942.45694.rototor@rototor.de>
In-Reply-To: <200702100942.45694.rototor@rototor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Emmeran.

There is no logged error on drive's side.  Only timeouts on host's side 
with BMDMA engine running.  I dunno specifics of the severwork 
controller but many controllers with BMDMA interface timeouts the 
command if transmission failure occurs, so my primary suspect is still 
hardware transmission problem which seems quite common in SATA world.

Can you try the followings?

1. Use different cable and connect the hdd to different hdd.

2. If possible, connect the harddisk to different power supply.  (I know 
you have juicy PSU but just in case)

Probably applying this to only one machine and leaving the other alone 
as control is a good idea.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S1030565AbXBAEWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030565AbXBAEWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 23:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030540AbXBAEWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 23:22:17 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63779 "EHLO
	pd5mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030565AbXBAEWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 23:22:16 -0500
Date: Wed, 31 Jan 2007 22:20:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by probe
 of partitions
In-reply-to: <fa.vUjkpPQXmle+uox6D228qG85KCU@ifi.uio.no>
To: TJ <linux@tjworld.net>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Message-id: <45C16AA5.7050808@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.vUjkpPQXmle+uox6D228qG85KCU@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TJ wrote:
> From: TJ <linux@tjworld.net>
> 
> Applies to: up-to and including 2.6.20-rc7 
> 
> This rare but critical bug has the potential to cause a hardware failure on disk drives by
> allowing the system to repeatedly attempt to seek to sectors beyond the end of the physical
> disk, causing sustained 'head banging'.

It seems pretty unlikely that telling a hard drive to seek past its 
capacity would cause it to damage itself, that would be some pretty 
moronic firmware. Though, you never know - if it's true, let me know 
what kind of drives these are, so I know never to buy one :-)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


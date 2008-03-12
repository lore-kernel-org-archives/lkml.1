Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbYCLMcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbYCLMcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYCLMcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:32:45 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:53901 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYCLMcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:32:45 -0400
X-Greylist: delayed 1885 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2008 08:32:45 EDT
In-Reply-To: <200803092346.17556.phillips@phunq.net>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.5 November 30, 2005
Message-ID: <OFEE15880F.3018E689-ON8025740A.0041A021-8025740A.004203F5@sophos.com>
From: tvrtko.ursulin@sophos.com
Date: Wed, 12 Mar 2008 12:01:03 +0000
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.2FP1|January 10, 2007) at
 12/03/2008 12:01:04,
	Serialize complete at 12/03/2008 12:01:04
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel-owner@vger.kernel.org wrote on 10/03/2008 06:46:16:

> Every little factor of 25 performance increase really helps.
> 
> Ramback is a new virtual device with the ability to back a ramdisk
> by a real disk, obtaining the performance level of a ramdisk but with
> the data durability of a hard disk.  To work this magic, ramback needs
> a little help from a UPS.  In a typical test, ramback reduced a 25
> second file operation[1] to under one second including sync.  Even
> greater gains are possible for seek-intensive applications.

What about doing a similar thing as a device mapper target? Have a look a 
dm-cache, I know that development of that has stopped but it doesn't mean 
it couldn't be ressurected. It has an advantage that it is generic (any 
two block devices will do) and you don't need to populate the "cache" on 
start-up - it happens automatically through cache misses.

Another use could be a flash based disk accelerator which may be pretty 
popular nowadays.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.


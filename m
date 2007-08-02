Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbXHBPVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbXHBPVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbXHBPVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:21:37 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:57326 "EHLO
	outbound4-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbXHBPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:21:36 -0400
X-BigFish: VP
X-FB-SS: 0,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Thu, 2 Aug 2007 09:23:19 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: ashwillis@programmer.net
cc: linux-kernel@vger.kernel.org, tiwai@suse.de, rafalbilski@interia.pl
Subject: Re: CS5530 Alsa driver fails
Message-ID: <20070802152319.GA25325@cosmic.amd.com>
MIME-Version: 1.0
In-Reply-To: <20070802135700.09319306@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 02 Aug 2007 15:21:23.0982 (UTC)
 FILETIME=[C97EF2E0:01C7D518]
X-WSS-ID: 6AAF29FE7CS3968654-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> I wouldn't mind porting VSA2 support to ALSA. I just don't have test
>> hardware. Do you happen to know any examples of hardware that run VSA2
>> firmware or is it just a case of a firmware update?

> Anything from the natsemi era onwards ought to be VSA2

VSA2 is mainly used to support the GX and LX processors, and the 
CS5535 and CS5536 southbridges.  The southbridges both have 
native AC97 controllers, supported by the snd-cs5535 driver
in the kernel and maintained by Jaya Kumar.

These just work, straight out of the box.

And as an aside, the VSA2 source code is open, so you can peruse
it and discover its secrets for yourself:

http://dev.laptop.org/git.do?p=geode-vsa;a=tree;hb=HEAD

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.



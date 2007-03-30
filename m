Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbXC3TKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbXC3TKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXC3TKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:10:38 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:49052 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXC3TKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:10:37 -0400
Date: Fri, 30 Mar 2007 21:09:36 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Eduard Bloch <edi@gmx.de>
cc: linux-kernel@vger.kernel.org, debburn-devel@lists.alioth.debian.org
Subject: Re: broken device locking, sg vs. sg_io on block devices
In-Reply-To: <20070330142114.GA31685@rotes76.wohnheim.uni-kl.de>
Message-ID: <Pine.LNX.4.61.0703302107140.31834@yvahk01.tjqt.qr>
References: <200703261811.21448.gerald@itzgrund.net>
 <20070330111744.GA8889@rotes76.wohnheim.uni-kl.de> <20070330134327.GA24030@infradead.org>
 <20070330142114.GA31685@rotes76.wohnheim.uni-kl.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 30 2007 16:21, Eduard Bloch wrote:
>> 
>> First the hardsware is broken when it can't deal with concurrent requests,
>> I'd try to get a refund for it.  Second wodim should never ever use
>> /dev/sg if the sr node is available.  And third HAL should stop poking
>> devices all the time.  Then again hald is a totally lost cause and
>> I can only recommend to uninstall it ASAP.

As part of opensuse 10.2, I do have hald running. It has not interfered
with cd writing so far. Though, I do not run any automounter like autofs or
ivman.

> - there is a fixed mapping between the fake-SCSI numbers and devices
>   established by Schilling.

It accepts dev=/dev/hdc, even if noone wants to admit it.

> - hald is installed together with KDE. Do you suggest to remove KDE as
>   well? I don't think so.

hald is installed as part of the base system, not kde. (If I uninstall it,
stuff like battery status on textconsole ceases to work here.)


Jan
-- 

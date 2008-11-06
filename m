Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbYKFVpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbYKFVpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYKFVpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:45:16 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:19840 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbYKFVpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:45:14 -0500
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <49136561.1050907@tremplin-utc.net>
Date: Thu, 06 Nov 2008 22:45:05 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@osdl.org>
Cc: Thomas Renninger <trenn@suse.de>, burman.yan@gmail.com, rpurdie@rpsys.net,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Kay Sievers <kasievers@suse.de>, hmh@hmh.eng.br
Subject: Re: leds-hp-disk vs lis3lv02d
References: <200810162255.m9GMtKj4001733@imap1.linux-foundation.org> <4902F817.4050108@tremplin-utc.net> <20081026174023.GA1847@ucw.cz> <200810271345.04961.trenn@suse.de> <20081106121405.GA1601@ucw.cz>
In-Reply-To: <20081106121405.GA1601@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek schreef:
>>> OTOH  it should 
>>> not block merge; both drivers still work and are useful.
>> But for long-term the HPQ0004 specific things in the lids3v driver should get 
>> merged with your HP leds driver also registering for HPQ0004 and the lids3v 
>> specific things should get a separate driver which HPQ0004 driver makes use 
>> of?
>> So in the end also for the HPQ0004 device only one driver should register for?
> 
> Yep... and this is the step in that direction. Relative to my previous
> patch...
> 
> Later led stuff will get merged to hp_accel.c...
Hi Pavel,
Just to say I like this approach. It should be completely compatible 
with the idea of allowing different buses (SPI and I²C) as well. Of 
course, I wish it could be possible to have the led and accelerometer 
drivers separated because they have no common point but the fact that 
they are advertised by the same PNP ID. But I can deal with that.

Andrew, is there anything preventing the merge of the lis3lv02d driver 
from your tree to Linus' one? I think it's still worth to integrate it 
as is, and later on this refactoring can take place.

See you,
Eric

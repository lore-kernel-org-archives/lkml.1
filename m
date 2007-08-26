Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbXHZHlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbXHZHlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 03:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbXHZHlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 03:41:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41648 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbXHZHlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 03:41:36 -0400
Date: Sun, 26 Aug 2007 09:41:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rob Landley <rob@landley.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: What's up with CONFIG_BLK_DEV?
In-Reply-To: <200708260108.28584.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0708260937400.15614@fbirervta.pbzchgretzou.qr>
References: <200708241517.28475.rob@landley.net>
 <Pine.LNX.4.64.0708242234250.28540@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0708242234500.28540@fbirervta.pbzchgretzou.qr>
 <200708260108.28584.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26 2007 01:08, Rob Landley wrote:
>On Friday 24 August 2007 3:36:54 pm Jan Engelhardt wrote:
>> >>Is there _ever_ a time you want the block layer but no block devices?
>>
>> Well, where do you think your hard disk drivers come from? Definitely
>> not from the BLK_DEV menu...
>
>Now that I look I see that all the devices in this menu (at least in User Mode 
>Linux) are actually virtual block devices (UBD, loopback, and ramdisk), which 
>the menu help doesn't indicate.

Nah, BLK_DEV is like MISC_DEV. There's all sort of stuff in it, _not only_
virtual things. FLOPPY comes to mind.


	Jan
-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbXCRVm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbXCRVm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933295AbXCRVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:42:29 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:37869 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280AbXCRVm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:42:26 -0400
Message-ID: <45FDAAB2.8010208@tremplin-utc.net>
Date: Sun, 18 Mar 2007 22:10:10 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Vojtech Pavlik <vojtech@suse.cz>, mitr@volny.cz, otauber@web.de,
       linux-kernel@vger.kernel.org,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
Subject: [PATCH 0/3] wistron_btns: More keymaps, take 2
References: <45ECA23A.5010503@tremplin-utc.net> <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com> <45ED8809.70309@tremplin-utc.net> <45F72D37.6090004@tremplin-utc.net> <d120d5000703140654y4d8cb0a3oafd49c48a045bd77@mail.gmail.com> <20070314182559.GC5264@suse.cz> <d120d5000703141158t4d02b8b7pc4ab967722dac@mail.gmail.com> <20070314190254.GA5843@suse.cz> <45F91F73.8040200@tremplin-utc.net>
In-Reply-To: <45F91F73.8040200@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a new version of my patch to add support for more laptops to the 
wistron_btns driver. Modifications from the previous version:
* sends lid close/open event as a switch event (not a key event)
* Display on/off is KEY_SCREEN and Display selection is 
KEY_SWITCHVIDEOMODE, from the discussion they seemed the "less bad" 
keycodes.
* keymaps are now declared initdata in order to save some memory


Patch 1 adds all the database of acerhk which fits this driver (about 25 
more laptops).
Patch 2 adds a generic map that should fit most users but has the 
disadvantage of not being automatic.
Patch 3 declares all the keymaps as initdata and copy the right one in 
memory.

Dmitry, I've tried to make them against your tree (tm610 already 
applied). Still, if they don't apply cleanly, just tell me and I'll try 
harder!

See you,
Eric

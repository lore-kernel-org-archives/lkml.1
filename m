Return-Path: <linux-kernel-owner+w=401wt.eu-S1751286AbXDKIcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbXDKIcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXDKIcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:32:50 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:59467 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbXDKIct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:32:49 -0400
Date: Wed, 11 Apr 2007 10:32:01 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
Subject: Re: [PATCH 10/30] Use menuconfig objects - I2C
In-Reply-To: <20070411101412.6c5512e7@hyperion.delvare>
Message-ID: <Pine.LNX.4.61.0704111024090.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704102310310.32056@yvahk01.tjqt.qr> <20070411101412.6c5512e7@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,


On Apr 11 2007 10:14, Jean Delvare wrote:
>On Tue, 10 Apr 2007 23:11:41 +0200 (MEST), Jan Engelhardt wrote:
>> 
>> Use menuconfigs instead of menus, so the whole menu can be disabled at        
>> once instead of going through all options.
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>
>The patch looks OK to me, except that it needs to be adjusted for the
>current state of the i2c subsystem. This kind of patch should be built
>on top on Andrew Morton's latest tree, not Linus Torvalds'.
>
>What is the merge plan?

If it applies with not too many rejects, take it and fixup
potentially new config options.
Else
  If Andrew's latest is a tarball or some sort of file (it is),
  I can redo it (with a big grumpy face ;-)
  Else
    You have to do it.

I think that's the typical way of doing things.
Documentation/SubmittingPatches only mandates latest kernel version 
(which most likely means Linus's tree), I could rebase.

Thanks,
Jan
-- 

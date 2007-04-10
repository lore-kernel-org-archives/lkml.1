Return-Path: <linux-kernel-owner+w=401wt.eu-S1030619AbXDJWbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030619AbXDJWbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030624AbXDJWbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:31:18 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:49682 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030619AbXDJWbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:31:08 -0400
Date: Wed, 11 Apr 2007 00:30:47 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Al Boldi <a1426z@gawab.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
In-Reply-To: <200704110112.39425.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.61.0704110026250.32056@yvahk01.tjqt.qr>
References: <200704110112.39425.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 01:12, Al Boldi wrote:
>Jan Engelhardt wrote:
>> the following patch series turns some menus into menuconfigs, so they
>> can be disabled whilst "walking" thorugh the parent menu
>
>Great, but instead of making it a simple on/off, make it tri-state that would 
>default select all child-options appropriately.  (see HW_RANDOM)

I do not remember having touched the Random Number Generators or Character
Devices anywhere in this series.

Don't worry, I have paid attention (or at least I hope so ;-) to 
'm'-able options, for example the SCSI, IEEE1394, or I2C stacks.

But, for example you will see
 [*] Old CD-ROM drivers (not SCSI, not IDE)

which is because this entry in itself does not generate any object file.

Generally, I just made the 'menuconfig' entry have the same state 
(bool/tristate) as the original entry. If I have overseen that 
somewhere, please let me know!


Thank you,
Jan
-- 

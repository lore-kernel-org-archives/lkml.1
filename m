Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbXDKIPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbXDKIPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXDKIPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:15:22 -0400
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:2116 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbXDKIPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:15:20 -0400
Date: Wed, 11 Apr 2007 10:14:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
Subject: Re: [PATCH 10/30] Use menuconfig objects - I2C
Message-ID: <20070411101412.6c5512e7@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.61.0704102310310.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704102310310.32056@yvahk01.tjqt.qr>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Tue, 10 Apr 2007 23:11:41 +0200 (MEST), Jan Engelhardt wrote:
> 
> Use menuconfigs instead of menus, so the whole menu can be disabled at        
> once instead of going through all options.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Well, in practice it was already possible to disable all I2C options at
once. The real difference is that it's now done directly from the main
Device Drivers menu. And we no longer have to express the dependency on
I2C in each Kconfig entry, which is nice.

The patch looks OK to me, except that it needs to be adjusted for the
current state of the i2c subsystem. This kind of patch should be built
on top on Andrew Morton's latest tree, not Linus Torvalds'.

What is the merge plan?

-- 
Jean Delvare

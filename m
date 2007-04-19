Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXDSUxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXDSUxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965153AbXDSUxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:53:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:32402 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280AbXDSUxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=T/utPZDz6h/rmmgKmXibtYIj0vcfhVeD3vbqtwDMpf/9OFJ35r4DopDfUuc0YyS8t64UWUlLxo0i7Jl11qvOBnVwXibkJOwrU1oavtiK73FpLFVd7XtE2XKq3oDPp7ScOLsCcVO053v1ZAL/hJ/517qerPW+a6riwZGL+VnbOts=
Message-ID: <4627D6CB.1050107@gmail.com>
Date: Thu, 19 Apr 2007 23:53:31 +0300
From: Sergey Yanovich <ynvich@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The device is present in many notebooks. Notebooks depend heavily on 
suspend/resume functionality. tifm_core/7xx1/sd family is an ambitous, 
but uncompleted project. It used to crash on resuming, or hang up on 
suspending. A less common failure used to be trigerred by a fast card 
insert/removal sequence. Finally, tifm_sd module needs to be manually 
inserted.

I have found it easier to rewrite the driver, than to fix. This driver 
is kind of mutant. The bones are taken from sdhci and omap, the meat - 
from tifm_*. It contains all features (and bugs except named above) of 
tifm_* as it was in kernel 2.6.21-rc7.

I have been testing this version since linux-2.6.18 (daily reading 
photos from cards, daily suspending/resuming) without a single glitch.

This patch only provides sources.
http://bugzilla.kernel.org/attachment.cgi?id=11238&action=view
 
Kernel configuration in this message.
http://bugzilla.kernel.org/attachment.cgi?id=11239&action=view

Alex Dubov has done exceptionally great lots of work to teach linux 
speak to TIFM. This is just a reorganization of his project.

The driver seems to be practically stable, but it definitely must be 
tested by more people. Please also report any issues with this driver to 
http://bugzilla.kernel.org/show_bug.cgi?id=8352 so that valuable info is 
not lost.

Best regards,
Sergey Yanovich


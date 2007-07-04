Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbXGDQo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbXGDQo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbXGDQoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:44:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:31897 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbXGDQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=JT4Z29HNcSaBxk0nfy9YyVe51O946RCvOHuszvHD7xf41lFwbYO76YU5IihjZ3ITZ9mfbTT8FXsNX5w/Y35tW5p0vk+/sK4rQC8ezY5STDzRggfC35OjWQQ749lv4iaJII27nqOe5CGvoo3oUsDnolP15LoRg/QwvPV0f/LdCEI=
Message-ID: <468BCE5C.6000707@googlemail.com>
Date: Wed, 04 Jul 2007 18:44:12 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Subject: [SCSI] SD driver question
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is there any reason why sd is printing the driver informations for each 
disk twice in dmesg ?

...

sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
sd 0:0:0:0: [sda] 35843670 512-byte hardware sectors (18352 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports 
DPO and FUA
sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0

etc
...


Is a bit annoying and floodish ;) on boxes with a lot SCSI , *ATA disks.


Regards,

Gabriel C



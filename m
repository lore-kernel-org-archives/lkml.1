Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbZKZN3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbZKZN3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 08:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759600AbZKZN3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 08:29:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46350 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759524AbZKZN3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 08:29:50 -0500
From: "Chaithrika U S" <chaithrika@ti.com>
To: "'A. Porodko'" <panda@chelcom.ru>, "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
       "'Jaroslav Kysela'" <perex@perex.cz>, "'Takashi Iwai'" <tiwai@suse.de>,
       "'Troy Kisky'" <troy.kisky@boundarydevices.com>,
       "'David Brownell'" <dbrownell@users.sourceforge.net>,
       "'Kevin Hilman'" <khilman@deeprootsystems.com>,
       <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
References: <4B0E7D5E.3080906@chelcom.ru>
In-Reply-To: <4B0E7D5E.3080906@chelcom.ru>
Subject: RE: Sound support for Neuros OSD2 Davinci based board.
Date: Thu, 26 Nov 2009 18:57:19 +0530
Message-ID: <002e01ca6e9c$2dab6040$890220c0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcpumHiLbLMLeHtfQi6Wjo9BLd3hpgAAzPYw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 26, 2009 at 18:36:38, A. Porodko wrote:
> Hello,
> 
> Here is a patch for Neuros OSD2 Davinci (DM6446) based board sound support.
> Patch made against 2.6.32-rc6 kernel.
> ------------------------------------------
> 
> --
> Best regards
> Andrey A. Porodko
>  
> 
> 
@@ -246,6 +249,9 @@ static int __init evm_init(void)
 	if (machine_is_davinci_evm()) {
 		evm_snd_dev_data = &evm_snd_devdata;
 		index = 0;
+	} else if (machine_is_neuros_osd2()) {
+		evm_snd_dev_data = &evm_snd_devdata;
+		index = 0;

The above can be combined with the check for DaVinci EVM
	if (machine_is_davinci_evm() ||
				(machine_is_neuros_osd2()) {
 		evm_snd_dev_data = &evm_snd_devdata;
 		index = 0;
	
Regards, 
Chaithrika



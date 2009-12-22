Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZLVPmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZLVPmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZLVPmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:42:22 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:10497 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZLVPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:42:21 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B30E8DA.9040705@tremplin-utc.net>
Date: Tue, 22 Dec 2009 16:42:18 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Mandriva/3.0-4mdv2010.1 (2010.1) Thunderbird/3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org, perex@perex.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.33-rc1] [SOUND] HDA: high cpu usage, noise
References: <8db1092f0912200927y7cdab36ftd1f73d56cd89763f@mail.gmail.com>	<s5hmy1cpqo4.wl%tiwai@suse.de>	<8db1092f0912211012mcdd6639oaaf0bddc118e7d66@mail.gmail.com>	<4B2FC7B2.7000001@tremplin-utc.net>	<s5hk4wf1obu.wl%tiwai@suse.de>	<4B308E28.1090609@tremplin-utc.net>	<s5hk4wfz7tm.wl%tiwai@suse.de>	<4B30E2AD.8010709@tremplin-utc.net> <s5htyvjggp6.wl%tiwai@suse.de>
In-Reply-To: <s5htyvjggp6.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-12-09 16:40, Takashi Iwai schreef:
:
> 
> Do you have multiple HD-audio devices?  See /proc/asound/cards.
> If there are multiple, you need to pass a value for each.

# cat /proc/asound/cards
 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xe0624000 irq 17

So I guess there is only one device.

Eric

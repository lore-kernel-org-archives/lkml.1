Return-Path: <linux-kernel-owner+w=401wt.eu-S1763768AbXHAMgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763768AbXHAMgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbXHAMg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:36:27 -0400
Received: from [80.75.67.54] ([80.75.67.54]:57215 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756509AbXHAMg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:36:26 -0400
X-Greylist: delayed 1289 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2007 08:36:26 EDT
Subject: Re: [alsa-devel] [RFC][PATCH] Get rid of dead code in
	sound/pci/ac97/ac97_patch.c
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46AF9D47.5090302@googlemail.com>
References: <46AF9D47.5090302@googlemail.com>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 13:14:56 +0100
Message-Id: <1185970496.3078.181.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'd prefer we keep this code in atm. The WM97xx touch driver needs it to
eliminate any audio noise from the touchscreen ADC.

I'll post the remaining touch driver patches in time for the next merge
window. 

Liam 

On Tue, 2007-07-31 at 22:36 +0200, Michal Piotrowski wrote:
> Hi,
> 
> File /home/devel/linux-rdc/sound/pci/ac97/ac97_patch.c line 484
> Unknown CONFIG option! CONFIG_TOUCHSCREEN_WM9705
> 
> Regards,
> Michal
> 


Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbYEUXus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbYEUXus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbYEUXuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:50:40 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:46695 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbYEUXuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:50:40 -0400
Message-ID: <4834B5E2.3040301@keyaccess.nl>
Date: Thu, 22 May 2008 01:53:06 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: Moving sound/* to drivers/ ?
References: <s5hzlqjz74d.wl%tiwai@suse.de> <4834B252.1080700@garzik.org>
In-Reply-To: <4834B252.1080700@garzik.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-05-08 01:37, Jeff Garzik wrote:

> Speaking as a former OSS driver maintainer, I always preferred 
> drivers/sound.
> 
> Though Rene's suggestion (use both sound/ and drivers/sound/) might make 
> sense if the subsystem code is huge -- I supported the drivers/block/ -> 
> block/ code movement for example.

Well, not _huge_ but ALSA is very much structured like that; large 
middle layer with "miniport" drivers (I do by the way expect this was 
also Takashi plan originally due to him using sound/* and not just 
"sound/"; that is, I took the * to be shorthand for isa, pci, usb and so on)

 From a structural view, the PCM core is just as much not a driver as 
the IP protocol isn't one and moving all of sound/ to drivers/ would 
trade the current "why are the drivers not under drivers/?" issue for a 
"why is all this non-driver code under drivers/?".

This "net model" of sound/ and drivers/sound/ would be cleanest I feel.

Rene.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYEVPuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYEVPuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYEVPub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:50:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51907 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbYEVPub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:50:31 -0400
Date: Thu, 22 May 2008 17:50:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Takashi Iwai <tiwai@suse.de>, Rene Herman <rene.herman@keyaccess.nl>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: Moving sound/* to drivers/ ?
In-Reply-To: <alpine.LFD.1.10.0805220758000.3081@woody.linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0805221735570.9332@fbirervta.pbzchgretzou.qr>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <4834B252.1080700@garzik.org> <4834B5E2.3040301@keyaccess.nl> <s5hy7623fqs.wl%tiwai@suse.de> <alpine.LNX.1.10.0805221052050.971@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.1.10.0805220758000.3081@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-22 17:04, Linus Torvalds wrote:
>On Thu, 22 May 2008, Jan Engelhardt wrote:
>> 
>> I am in favor of keeping /sound around with the
>> non-hardware-dependent code, much like /block does with regard to
>> /drivers/block.
>
>I'd personally *much* rather have just one subdirectory.
>[...] BUT:
> - perhaps more importantly, it's totally different from 'sound' in that 
>   the block/ and drivers/block/ maintainership is actually *separate*.
>[...]
>So I'd personally much rather see just one drivers/sound/ than have this 
>split up.

Surveille et rapport.

I took a look at how FreeBSD does this, just for comparison.
They have a single ${src}/dev/sound, but also no split "net" otoh
afaics. As always, if you think Linux should have a drivers/sound/,
just direct your lieutenants to do so.

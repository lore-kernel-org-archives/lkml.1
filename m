Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYEVQiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYEVQiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYEVQiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:38:09 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:45706 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYEVQiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:38:08 -0400
Message-ID: <4835A1FF.3050902@keyaccess.nl>
Date: Thu, 22 May 2008 18:40:31 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Engelhardt <jengelh@medozas.de>, Takashi Iwai <tiwai@suse.de>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: Moving sound/* to drivers/ ?
References: <s5hzlqjz74d.wl%tiwai@suse.de> <4834B252.1080700@garzik.org> <4834B5E2.3040301@keyaccess.nl> <s5hy7623fqs.wl%tiwai@suse.de> <alpine.LNX.1.10.0805221052050.971@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0805220758000.3081@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805220758000.3081@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-05-08 17:04, Linus Torvalds wrote:

> On Thu, 22 May 2008, Jan Engelhardt wrote:

>> I am in favor of keeping /sound around with the
>> non-hardware-dependent code, much like /block does with regard to
>> /drivers/block.
> 
> I'd personally *much* rather have just one subdirectory.

Then I'd agree/suggest ALSA move to drivers/sound. I brought it up but 
both Jaroslav and Takashi agree with you. For me it was more a "nicely 
reflects the design of things" issue than anything else...

I do agree that the drivers are better of in drivers/ and they are 10 
times the size of the sound core.

Rene.

Return-Path: <linux-kernel-owner+w=401wt.eu-S934116AbXIBWVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116AbXIBWVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933998AbXIBWVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:21:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49982 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbXIBWVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:21:07 -0400
Date: Mon, 3 Sep 2007 04:04:14 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rene Herman <rene.herman@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH -mm] sb16: Shut up uninitialized var build warning
In-Reply-To: <46DB33D0.40204@gmail.com>
Message-ID: <alpine.LFD.0.999.0709030358410.31154@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n> <alpine.LFD.0.999.0709030143550.29617@enigma.security.iitk.ac.in>
 <46DB33D0.40204@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-507949488-1188772458=:31154"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-507949488-1188772458=:31154
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Mon, 3 Sep 2007, Rene Herman wrote:
> 
> On 09/02/2007 10:15 PM, Satyam Sharma wrote:
> 
> > sound/isa/sb16/sb16.c: In function ‘snd_sb16_isa_probe’:
> 
> Blah. Your message has:
> 
> 	Content-Type: TEXT/PLAIN; charset=iso-2022-jp
> 
> This apparently is caused by a combination of GCC using groovy UTF tickmarks
> in its error messages when in a UTF locale and alpine believing it to be a
> great idea to automatically try for the "simplest" character set it can encode
> the content in. No idea why that means that iso-2022-jp is picked, but it is.

Yeah, precisely.

> As to the content of this patch -- I'd almost say it's better to live with the
> warning than with that unitialized_var() thing. That ARRAY_SIZE is very much a
> compile time constant, so exactly how dumb must GCC get before we get to say
> to here and no further?

Pretty dumb indeed -- in fact that's the case with 4 patches in this
series. Like Jeff said, that (gcc's) behaviour has likely even improved
w.r.t. later versions, so I guess it's fine if these 4 patches are not
applied -- I'll leave it upto the maintainers.
--464262402-507949488-1188772458=:31154--

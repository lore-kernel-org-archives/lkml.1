Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYKSKAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYKSKAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 05:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYKSKAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 05:00:39 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:50150 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYKSKAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 05:00:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=rnP/Mulltl2cFevQ3ag/jocMyS2+ASbVxioQpEcGXmpH5dclCahwY4H9B9nasldTCy
         oBbe9Ri1Ju4FoxpeVhGfomAUcHS3SrJMsX9milxkUkO7UpG+MjSRrb0NnGrKb7r9VOgJ
         IYWszuzzYDVQGJcYq+6eb9+ffKXE3Db4WzXrs=
Message-ID: <386072610811190200l576d7735rb0188ab53f5185fa@mail.gmail.com>
Date: Wed, 19 Nov 2008 18:00:36 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: [Question] Can I open a substream in kernel space without attach to a file pointer?
Cc: "ALSA devel" <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: cc7b45d44ed46d43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

I am developing a USB gadget driver compliant to USB Audio Class Spec 2.0.
So I want to open a PCM substream and do some playback of capture,
then close them?

I found snd_pcm_open_substream() is for opening a substream and attach
it to a file.
But in my application, there is no need to open a file before opening
a substream.

- Is there any interface for me to open a substream in kernel space
without attach to a file?
- How to playback and capture in kernel space, use snd_pcm_lib_write
and snd_pcm_lib_read?
- How to get the snd_pcm_hardware struct from low level driver,
because I have to get the hardware configuration of the snd pcm
device?

And I am reading the code of OSS emulator in ALSA. It provides some
info about the kernel space sound card programming.

Thanks a lot
-Bryan

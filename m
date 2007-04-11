Return-Path: <linux-kernel-owner+w=401wt.eu-S1750898AbXDKHUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898AbXDKHUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXDKHUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:20:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:53196 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbXDKHUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H64Q/BRxlD6Uk7q99xHMxyyYGYla13tdbtZTpNR/zkIF4Vy+SK0GDOM+wybT+5BxFRk/zR4KymQGnxaVtiMTQBFbSKDdMB0C2aD5uwJLaZ5SOCGJDkFdJPUgJyw0EApKoWv2yCIdk763v5qKbl03QIOcaAQnChgQv1B1FdpqXYg=
Message-ID: <d9def9db0704110020r5bf529e3q52bed9e2f0db394a@mail.gmail.com>
Date: Wed, 11 Apr 2007 09:20:08 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "code GG" <codegg@gmail.com>
Subject: Re: Does V4L driver support audio capture?
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <3f94553e0704100631k622774ds1a60178abc491fab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f94553e0704100631k622774ds1a60178abc491fab@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, code GG <codegg@gmail.com> wrote:
> Hi all,
>     Are there any V4L API supporting audio capture (supposing the TV
> card hardware has such ability), just like the APIs and structures for
> video capture?
>

for capturing usually OSS or alsa is used, you might have a look at
the em28xx code and search for audio (VIDIOC_G_AUDIO, VIDIOC_S_AUDIO)

there are drawbacks at the moment that you usually don't know what
audio device belongs to your TV card if you want to capture audio
digitally without looking at your dmesg or reading the individual
description of the created audio device (userspace applications
usually don't know about that and you have to set up the soundcard -
tvtuner bridge manually)

Markus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYECX0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYECX0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbYECX0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:26:05 -0400
Received: from lucidpixels.com ([75.144.35.66]:50514 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbYECX0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:26:03 -0400
Date: Sat, 3 May 2008 19:26:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Re: From 2.6.24 -> 2.6.25, lost audio (snd-hda-intel)
In-Reply-To: <alpine.DEB.1.10.0804221822520.6366@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0805031924380.7859@p34.internal.lan>
References: <alpine.DEB.1.10.0804221822520.6366@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008, Justin Piszcz wrote:

>        Kernel modules: snd-hda-intel
> 00: 86 80 d8 27 06 00 10 00 01 00 03 04 08 00 00 00
> 10: 04 80 ff fd 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 7b 14 7a 10
> 30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00
>
>

Found problem:

$ aumix -q
vol 100, 100
line 100, 100
mic 100, 100
cd 100, 100
pcm2 100, 100
igain 100, 100
dig1 100, 100, R

There is no 'pcm' with aumix anymore.

I used alsamixer and boosted up the pcm and its fine now.

Justin.


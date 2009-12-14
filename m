Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZLNM06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZLNM06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbZLNM04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:26:56 -0500
Received: from borg.medozas.de ([188.40.89.202]:33699 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188AbZLNM0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:26:55 -0500
Date: Mon, 14 Dec 2009 13:26:53 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Nir Tzachar <nir.tzachar@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: nconfig v7
In-Reply-To: <9b2db90b0912132141j6b06d26dgd1e14acf3631de13@mail.gmail.com>
Message-ID: <alpine.LSU.2.01.0912141325220.21244@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr>  <9b2db90b0912122323w25d2d815o70d0bd2f1e19a228@mail.gmail.com>  <alpine.LSU.2.01.0912131118280.28039@obet.zrqbmnf.qr> <9b2db90b0912132141j6b06d26dgd1e14acf3631de13@mail.gmail.com>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 2009-12-14 06:41, Nir Tzachar wrote:

>>>> - I get a visual glitch (see Exhibit A below) in General setup (patch
>>>>  slapped onto 2.6.32); the left frame part is missing.
>>>
>>>I cannot reproduce this. Can you provide some more details? (e.g.,
>>>which terminal, $LINES, $COLUMNS, $TERM)
>>
>> xterm -bg black -fg gray -geometry 80x25
>
>I cannot reproduce this on any of my systems. Any idea how to
>proceed?? Can you also send a snapshot?
>

Add this to the top of arch/x86/Kconfig:

config VERY_LONG_CONFIGURATION_OPTION 
   bool "With a very long long description, you see where this is going"

to reproduce the effect on ARCH=x86.

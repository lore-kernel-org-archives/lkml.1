Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZFUAOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZFUAOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 20:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZFUANv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 20:13:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56138 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751382AbZFUANu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 20:13:50 -0400
References: <1245403695-20537-1-git-send-email-21cnbao@gmail.com> <8bd0f97a0906190405k33503d8ekd74ec9ddbb2fde12@mail.gmail.com> <A40FAF28-889C-4322-A114-098EEA56FCE6@opensource.wolfsonmicro.com> <200906201915.39935.rgetz@blackfin.uclinux.org> (sfid-20090621_001240_652537_BCBB3B6E)
Message-Id: <982CEEB9-22E6-4CE6-833F-806D31E8D6B8@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
In-Reply-To: <200906201915.39935.rgetz@blackfin.uclinux.org> (sfid-20090621_001240_652537_BCBB3B6E)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7A341)
Mime-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: [alsa-devel] [PATCH] New ASoC Drivers for ADI AD1938 codec
Date: Sun, 21 Jun 2009 01:13:39 +0100
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       Mike Frysinger <vapier.adi@gmail.com>, Barry Song <21cnbao@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 21 Jun 2009, at 00:15, Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> Any reason why platform/board specific things are in sound/soc/arch  
> rather
>>>
>>
> than arch/xxxx/boards - like the majority of drivers?

Partly because the APIs are sufficiently fluid to make the cross tree  
merge issues unmanageable, partly because non trivial boards really do  
need an entire driver for the board. I'd also say that at the minute  
I'm catching enough errors on review of machine drivers to make it  
worthwhile.
>

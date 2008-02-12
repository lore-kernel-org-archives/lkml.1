Return-Path: <linux-kernel-owner+w=401wt.eu-S1764638AbYBLUdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764638AbYBLUdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbYBLUdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:33:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780AbYBLUdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:33:24 -0500
Message-ID: <47B2025B.1030103@zytor.com>
Date: Tue, 12 Feb 2008 12:32:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
CC: Joey Hess <joeyh@debian.org>, 464962@bugs.debian.org,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Bug#464962: immediate crash on boot on TM5800
References: <20080210031849.GA3370@dragon.kitenet.net> <20080210110659.GB8574@stro.at> <20080210192139.GA17647@kodama.kitenet.net> <20080212160522.GB5221@stro.at> <20080212195254.GA6252@kodama.kitenet.net> <20080212201048.GD22054@baikonur.stro.at>
In-Reply-To: <20080212201048.GD22054@baikonur.stro.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maximilian attems wrote:
> 
> sure, ack.
> so i'll circumvent bugzilla and add the new x86 maintainers
> on cc to let them know about the 2.6.24 and 2.6.25-rc1 boot error
> on shiny fujitsu p700 lifebook, with a Crusoe processor.
> http://bugs.debian.org/464962
> 686 config attached.
> 

INT 6 is #UD, undefined instruction.

If you could send me a copy of your vmlinux file (not bzImage), it would 
speed things up.

I happen to have an old TM5800-based machine sitting around, so I can 
probably reproduce it.

	-hpa

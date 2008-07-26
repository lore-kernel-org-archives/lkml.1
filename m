Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYGZSGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYGZSGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYGZSGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:06:14 -0400
Received: from ackle.nomi.cz ([81.31.33.35]:38823 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYGZSGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:06:13 -0400
Date: Sat, 26 Jul 2008 20:06:10 +0200
From: =?iso-8859-2?Q?Tom=E1=B9_Janou=B9ek?= <tomi@nomi.cz>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Message-ID: <20080726180610.GA12168@nomi.cz>
References: <20080726154617.GA5613@notes.lisk.in> <20080726195521.36d4d48c@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080726195521.36d4d48c@i1501.lan.towertech.it>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jul 26, 2008 at 07:55:21PM +0200, Alessandro Zummo wrote:
>  I'm not sure this is appropriate. sometimes the PIE is used to control
>  external hardware and it doesn't make sense to have an application that's
>  always open to handle that. 
> 
>  Any app should be responsible to release what it has allocated, if appropriate,
>  and not rely on someone else to do on his behalf.

mplayer and aireplay-ng have never done so. And what about crashes? Am I
supposed to create a small "rtcpieoff" applications and make it into all
distributions so that everyone can clean up the mess?

Additionally, it has been a regression against the old rtc and drivers like
rtc-sh do so even today.

-- 
Tomá¹ Janou¹ek, a.k.a. Liskni_si, http://work.lisk.in/

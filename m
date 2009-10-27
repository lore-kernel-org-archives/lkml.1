Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbZJ0BOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbZJ0BOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbZJ0BOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:14:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59841 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbZJ0BOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:14:21 -0400
Date: Mon, 26 Oct 2009 18:14:14 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.32-rc not booting with Xen-3.2 (bisected)
In-Reply-To: <4AE628DB.5010305@goop.org>
Message-ID: <alpine.DEB.2.01.0910261759470.9408@bogon.housecafe.de>
References: <alpine.DEB.2.01.0910261445170.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261513520.9408@bogon.housecafe.de> <4AE628DB.5010305@goop.org>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+LLKlqYg/fKyW0A3/2wHQ6fHtTOBgC+pM6h0r
 rFTvHUGQ8TIyegn8BHNbNtcDzaYyiVR9HYrI/2dwx6rmykBxJt
 NEeurzSHU2oIOBDispj3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 at 15:55, Jeremy Fitzhardinge wrote:
> Yes, that is indeed a likely suspect.

Is there any way I can bisect this any further, i.e. which change of this 
merge is causing this?

> Is Xen compiled with DEBUG=y? 

Hm, I doubt that the "stock" Ubuntu Xen packages are compiled with DEBUG 
flags. I've put the .config of the running Dom0 kernel here:

http://nerdbynature.de/bits/2.6.32/dom0/

> Does anything appear on the Xen console (xm dmesg)?

Oh, I totally forgot about "xm dmesg", it's on the URL above too. I don't 
see any timestamps in "xm dmesg", so I guess I'll have to try again with 
"xm dmesg --clear" inbetween boots.

Thanks,
Christian.
-- 
BOFH excuse #210:

We didn't pay the Internet bill and it's been cut off.

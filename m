Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbZKBGyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbZKBGyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 01:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZKBGya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 01:54:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54508 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZKBGya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 01:54:30 -0500
Date: Sun, 1 Nov 2009 22:53:58 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.32-rc not booting with Xen-3.2 (bisected)
In-Reply-To: <4AE7A816.3050607@goop.org>
Message-ID: <alpine.DEB.2.01.0911012249370.9408@bogon.housecafe.de>
References: <alpine.DEB.2.01.0910261445170.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261513520.9408@bogon.housecafe.de> <4AE628DB.5010305@goop.org> <alpine.DEB.2.01.0910261759470.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261820050.9408@bogon.housecafe.de>
 <4AE67506.2040200@goop.org> <alpine.DEB.2.01.0910262154410.9408@bogon.housecafe.de> <4AE73973.3070709@goop.org> <alpine.DEB.2.01.0910271158100.9408@bogon.housecafe.de> <4AE7A816.3050607@goop.org>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/RjreemCczVWBvf2K1D9BYz7G0PxK4R6XmSYx
 t/9QRzX9qpqrGk4uedvm43ag4MqkxZnEOUWMTkEiOu2NWVwm0x
 csPh+CjSL90NI5XT0hiAw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 at 19:10, Jeremy Fitzhardinge wrote:
> Please try the patch below.

I see the patch made it into mainline already[0], so I just tried the 
latest git checkout from Linus' tree and the DomU is booting now, with no 
other ill effects afaict.

Thanks so much for the quick fix!

Christian.

[0] 2e2ec952350f25242f2e0539db16b1e46f9eb01b
-- 
BOFH excuse #319:

Your computer hasn't been returning all the bits it gets from the Internet.

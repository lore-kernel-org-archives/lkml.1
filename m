Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZJ0FCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZJ0FCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 01:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZJ0FCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 01:02:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50474 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbZJ0FCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 01:02:19 -0400
Date: Mon, 26 Oct 2009 22:01:45 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.32-rc not booting with Xen-3.2 (bisected)
In-Reply-To: <4AE67506.2040200@goop.org>
Message-ID: <alpine.DEB.2.01.0910262154410.9408@bogon.housecafe.de>
References: <alpine.DEB.2.01.0910261445170.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261513520.9408@bogon.housecafe.de> <4AE628DB.5010305@goop.org> <alpine.DEB.2.01.0910261759470.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261820050.9408@bogon.housecafe.de>
 <4AE67506.2040200@goop.org>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19JhkSxEyemTha8Z7BT6LMrwZbm+rQsvl8It0j
 CZTYSoLz5pmGs+USt7zgy7W3t0mCw1mRJra8kTZKVW8jexNv4Z
 JApyieB8oHKhoE2+N/B2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 at 21:20, Jeremy Fitzhardinge wrote:
> What does this map to in the kernel symbol table?

Hm, I'm not sure how to answer this? Got a hint, please?

Christian.

> > Also, "xm list" takes very long to complete now:
> >
> > $ time xm list sid
> > Name                  ID   Mem VCPUs      State   Time(s)
> > sid                  906   512     1     --p---     0.0
> > real    0m10.677s user    0m0.108s sys     0m0.028s
> Hm, that's odd.  Never seen that.

The load of the Dom0 with the panicked DomU "running" higher than 
usual (3-4 instead of ~0) and xenstored is spinning and waiting for 
(causing?) disk I/O. This is not the case when the DomU is runing just 
fine. I didn't strace xenstored yet, because I don't want to risk
killing the whole Xen box.

Christian.
-- 
BOFH excuse #73:

Daemons did it

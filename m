Return-Path: <linux-kernel-owner+w=401wt.eu-S1765987AbYEPPKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765987AbYEPPKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbYEPOxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:53:51 -0400
Received: from mail11d.verio-web.com ([204.202.242.86]:29537 "HELO
	mail11d.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762516AbYEPOxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:53:49 -0400
Message-ID: <482D9FFA.9030402@sensoray.com>
Date: Fri, 16 May 2008 07:53:46 -0700
From: dean <dean@sensoray.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Greg KH <greg@kroah.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
References: <20080514205927.GA13134@kroah.com> <20080515235102.756407d3@gaivota>
In-Reply-To: <20080515235102.756407d3@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: [F=0.2357066621; S=0.235(2008040101); MH=0.500(2008040918)]
X-MAIL-FROM: <dean@sensoray.com>
X-SOURCE-IP: [161.58.148.42]
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Btw, I noticed the lack of Dean's SOB. Is this intentional?


It's not intentional, I can sign off on it.  The suggestions look good.

I have a few other questions.  First, is Video for Linux version 1 going 
to be obsoleted soon?  Do the V4L1 compatibility routines still work in 
the latest driver?  I had problems running the VIVI (virtual video 
driver) driver with VideoLan/VLC 0.8.6a-f, but it worked with VLC 9.0 
with the new V4L2 interface.

"videodev: "s2255v" has no release callback. Please fix your driver for 
proper sysfs support, see http://lwn.net/Articles/36850/"

Should we get rid of the warning message above? It's also been present 
in VIVI for quite a few kernel releases.




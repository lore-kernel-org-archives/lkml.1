Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbYHSVzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbYHSVzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760407AbYHSVx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:53:29 -0400
Received: from lucidpixels.com ([75.144.35.66]:53163 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760401AbYHSVx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:53:28 -0400
Date: Tue, 19 Aug 2008 17:53:27 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: User discussion about IVTV <ivtv-users@ivtvdriver.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [ivtv-users] Hauppauge 1192 WinTV-HVR-1950: Kernel Oops :(
In-Reply-To: <alpine.DEB.1.10.0808191631030.8579@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0808191752590.12937@p34.internal.lan>
References: <alpine.DEB.1.10.0808191631030.8579@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Justin Piszcz wrote:

> 2.6.26.2:
>
> [   15.745116] usbcore: registered new interface driver pvrusb2
> [   16.023474] pvrusb2: Device initialization completed successfully.

Closer now:

[  749.791189] pvrusb2: Device initialization completed successfully.
[  749.791214] pvrusb2: registered device video0 [mpeg]
[  749.791218] DVB: registering new adapter (pvrusb2-dvb)
[  749.824133] tda829x 1-0042: setting tuner address to 60
[  749.846540] tda18271 1-0060: creating new instance
[  749.877130] TDA18271HD/C1 detected @ 1-0060
[  750.817127] tda829x 1-0042: type set to tda8295+18271
[  755.394132] firmware: requesting v4l-cx2341x-enc.fw
[  757.528628] DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
[  757.530626] tda829x 1-0042: type set to tda8295
[  757.567455] tda18271 1-0060: attaching existing instance
[  767.156610] pvrusb2: WARNING: No decoder present

# cat /dev/video0
cat: /dev/video0: Input/output error



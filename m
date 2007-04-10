Return-Path: <linux-kernel-owner+w=401wt.eu-S1030826AbXDJPcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030826AbXDJPcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030825AbXDJPcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:32:10 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:48088 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030826AbXDJPcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:32:10 -0400
Message-ID: <461BAC6F.9040004@aitel.hist.no>
Date: Tue, 10 Apr 2007 17:25:35 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: dtor@insightbb.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: usb touchscreen breakage in 2.6.21-rc5-mm4 ?
References: <20070407005458.GA18985@aitel.hist.no>	<200704062237.13118.dtor@insightbb.com>	<20070409223643.GB2198@aitel.hist.no> <20070409180642.c9847de2.akpm@linux-foundation.org>
In-Reply-To: <20070409180642.c9847de2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Is 2.6.21-rc6 OK?
>
> If so, please keep a close eye on 2.6.22-rcX, let us know if/when we've
> moved this breakage into mainline :(
>   

2.6.21-rc6 is ok.
Here, I get messages from usbtouchscreen, something
rc5-mm4 failed to produce.
The egalax driver gets /class/input/input3,
usbcore registers usbtouchscreen, and the
touchscreen works. 

Well, it became /dev/input/event3 while
2.6.18 placed it at /dev/input/event1, but I think that
is more of a udev problem...

Helge Hafting


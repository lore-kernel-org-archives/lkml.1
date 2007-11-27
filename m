Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbXK0Wbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbXK0Wbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXK0Wbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:31:33 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:20834 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751745AbXK0Wbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:31:32 -0500
Message-ID: <474C9AC9.8000400@cfl.rr.com>
Date: Tue, 27 Nov 2007 17:31:37 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dave Jones <davej@redhat.com>, Stephen Clark <Stephen.Clark@seclark.us>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Power Saving
References: <47422D3B.8080704@seclark.us> <20071120005443.GB9243@redhat.com> <474232D9.20407@seclark.us> <20071120011236.GA17420@redhat.com> <474236A0.8030601@zytor.com>
In-Reply-To: <474236A0.8030601@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Nov 2007 22:31:47.0070 (UTC) FILETIME=[4B9639E0:01C83145]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15572.001
X-TM-AS-Result: No--9.463500-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> And more importantly, there is no power advantages over T states as 
> opposed to C states.  They pretty much mean pulsing the system in and 
> out of either C1 or C2 depending on the CPU/chipset.

Well, they FORCE the use of the C states to save power, even if the 
kernel doesn't want to because it still has runnable tasks.  This can be 
useful if you know you are running a task that busy waits but would not 
suffer from having the performance of the cpu cut in half.  Since it is 
busy waiting, the kernel never activates the C states, but the 
throttling will force it and thus, save you power and heat.



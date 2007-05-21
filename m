Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbXEUPyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbXEUPyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXEUPya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:54:30 -0400
Received: from www.osadl.org ([213.239.205.134]:53130 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754957AbXEUPy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:54:29 -0400
Subject: Re: [PATCH] -rt fix TSC calibration from PM Timer
From: Thomas Gleixner <tglx@linutronix.de>
To: Joachim Deguara <joachim.deguara@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200705211743.10402.joachim.deguara@amd.com>
References: <200705211743.10402.joachim.deguara@amd.com>
Content-Type: text/plain
Date: Mon, 21 May 2007 18:01:15 +0200
Message-Id: <1179763275.12708.4.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 17:43 +0200, Joachim Deguara wrote:
> The code to calibrate TSC frequency from the PM timer does not work on my 
> laptop with the 2.6.21-rt5.
> 
> [    0.247815] time.c: Detected 62117.606 MHz processor.

I know. The code was fixed in the x86_64-hrt queue, but never moved to
-rt. The sync to -hrt is already in the -rt6 pipeline.

	tglx


	


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbYAWWA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbYAWWA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYAWWAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:00:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYAWWAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:00:21 -0500
Message-ID: <4797B8C4.9060102@zytor.com>
Date: Wed, 23 Jan 2008 13:59:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ingo Molnar <mingo@elte.hu>,
       Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Jordan Crouse <jordan.crouse@amd.com>, Lars Heete <hel@admin.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] x86: GEODE fix MFGPT input clock value
References: <20080116165606.3ebc06a4@ephemeral> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <4795B14C.7040502@i4.informatik.rwth-aachen.de> <200801221111.21240.hel@admin.de> <4795D120.7070806@i4.informatik.rwth-aachen.de> <20080122192757.GC5241@cosmic.amd.com> <47965806.6080903@i4.informatik.rwth-aachen.de> <20080122211014.GA27870@elte.hu> <20080123211746.GA2969@1wt.eu> <20080123211859.GA3081@1wt.eu>
In-Reply-To: <20080123211859.GA3081@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> The GEODE MFGPT code assumed that 32kHz was 32000 Hz while the boards
> run on a 32.768 kHz digital watch crystal. In practise, it will not
> change the timer's frequency as the skew was only 2.4%, but it
> should provide more accurate intervals.
> - *  Divisor   Hz      Min Delta (S) Max Delta (S)

Seconds are "s", not "S" (S = siemens.)

	-hpa

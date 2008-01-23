Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYAWWMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYAWWMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYAWWLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:11:54 -0500
Received: from 1wt.eu ([62.212.114.60]:1569 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbYAWWLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:11:52 -0500
Date: Wed, 23 Jan 2008 23:11:29 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Jordan Crouse <jordan.crouse@amd.com>, Lars Heete <hel@admin.de>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] x86: GEODE fix MFGPT input clock value
Message-ID: <20080123221129.GA27022@1wt.eu>
References: <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <4795B14C.7040502@i4.informatik.rwth-aachen.de> <200801221111.21240.hel@admin.de> <4795D120.7070806@i4.informatik.rwth-aachen.de> <20080122192757.GC5241@cosmic.amd.com> <47965806.6080903@i4.informatik.rwth-aachen.de> <20080122211014.GA27870@elte.hu> <20080123211746.GA2969@1wt.eu> <20080123211859.GA3081@1wt.eu> <4797B8C4.9060102@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4797B8C4.9060102@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Jan 23, 2008 at 01:59:32PM -0800, H. Peter Anvin wrote:
> Willy Tarreau wrote:
> >The GEODE MFGPT code assumed that 32kHz was 32000 Hz while the boards
> >run on a 32.768 kHz digital watch crystal. In practise, it will not
> >change the timer's frequency as the skew was only 2.4%, but it
> >should provide more accurate intervals.
> >- *  Divisor   Hz      Min Delta (S) Max Delta (S)
> 
> Seconds are "s", not "S" (S = siemens.)

You're quite right. Same as we should write kHz and not Khz. But I'm
used to change other people's work and particularly comments the least
possible. Do you want an update ?

Willy


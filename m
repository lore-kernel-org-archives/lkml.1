Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYAWWhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYAWWhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYAWWhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:37:32 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40170 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694AbYAWWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:37:31 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Wed, 23 Jan 2008 15:38:30 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Willy Tarreau" <w@1wt.eu>
cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Arnd Hannemann" <hannemann@i4.informatik.rwth-aachen.de>,
       "Lars Heete" <hel@admin.de>, "Andres Salomon" <dilinger@queued.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: x86: GEODE fix MFGPT input clock value
Message-ID: <20080123223830.GA26219@cosmic.amd.com>
References: <4795B14C.7040502@i4.informatik.rwth-aachen.de>
 <200801221111.21240.hel@admin.de>
 <4795D120.7070806@i4.informatik.rwth-aachen.de>
 <20080122192757.GC5241@cosmic.amd.com>
 <47965806.6080903@i4.informatik.rwth-aachen.de>
 <20080122211014.GA27870@elte.hu> <20080123211746.GA2969@1wt.eu>
 <20080123211859.GA3081@1wt.eu> <4797B8C4.9060102@zytor.com>
 <20080123221129.GA27022@1wt.eu>
MIME-Version: 1.0
In-Reply-To: <20080123221129.GA27022@1wt.eu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 23 Jan 2008 22:37:01.0783 (UTC)
 FILETIME=[78B75E70:01C85E10]
X-WSS-ID: 6B891E100QK8644456-18-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/08 23:11 +0100, Willy Tarreau wrote:
> Hi Peter,
> 
> On Wed, Jan 23, 2008 at 01:59:32PM -0800, H. Peter Anvin wrote:
> > Willy Tarreau wrote:
> > >The GEODE MFGPT code assumed that 32kHz was 32000 Hz while the boards
> > >run on a 32.768 kHz digital watch crystal. In practise, it will not
> > >change the timer's frequency as the skew was only 2.4%, but it
> > >should provide more accurate intervals.
> > >- *  Divisor   Hz      Min Delta (S) Max Delta (S)
> > 
> > Seconds are "s", not "S" (S = siemens.)
> 
> You're quite right. Same as we should write kHz and not Khz. But I'm
> used to change other people's work and particularly comments the least
> possible. Do you want an update ?

Please do - I don't mind if you change the comments - better that they
are right.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.



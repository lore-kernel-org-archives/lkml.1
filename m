Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYA0T02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYA0T02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYA0T0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:26:18 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:43162 "EHLO
	outbound3-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062AbYA0T0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:26:17 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JVBHZE-01-1SD-01
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Sun, 27 Jan 2008 12:28:07 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Andrew Paprocki" <andrew@ishiboo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: lxfb is not changing modes, no errors/information printing
 out
Message-ID: <20080127192807.GF8635@cosmic.amd.com>
References: <76366b180801271045u7342540p58f5970a49c097be@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <76366b180801271045u7342540p58f5970a49c097be@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 27 Jan 2008 19:25:58.0948 (UTC)
 FILETIME=[71FC8E40:01C8611A]
X-WSS-ID: 6B82054D07S9195620-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/08 13:45 -0500, Andrew Paprocki wrote:
> Using 2.6.24, I can't get my Geode LX (LX800 CPU) to boot in anything
> other than the default 80x25 console even though lxfb appears to be
> loading normally. This device doesn't work with the VESA fb either
> when I request "vga=0x31a". All the other boards I have display a
> 1280x1024 console on my monitor. Are my kernel parameters wrong in
> some way? I tried "video=lxfb:<mode>" with and without "vga=0x31a".
> The driver is compiled into the kernel -- I am not using modules.

Can you change the mode after you have booted with 'fbset'?

> Also, a side note.. blanking on this display doesn't seem to work
> properly. When the screen would normally blank after a timeout, a thin
> ~20px width vertical black strip appears on the left-hand side of the
> screen, but the rest of the display area remains showing whatever
> contents were on the screen when the blank was triggered. Hitting a
> key goes back to displaying the current fb contents like you would
> expect.

Thanks for reporting that - thats a known bug, I'll send a patch to fix it.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.



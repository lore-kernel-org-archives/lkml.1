Return-Path: <linux-kernel-owner+w=401wt.eu-S932327AbYEVMgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbYEVMgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbYEVMgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:36:17 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39131 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831AbYEVMgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:36:16 -0400
X-Sasl-enc: GnSeedZJiCGCJ3HeMMzQXDHD1DK4S5QRQt4bokW7UACi 1211459774
Message-ID: <483568BD.4040701@ladisch.de>
Date: Thu, 22 May 2008 14:36:13 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Kallol Biswas <nucleodyne@gmail.com>
CC: Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: HDMI Audio Support in ALSA
References: <438397970805190904i2656337dh26a3257fe52aa29d@mail.gmail.com>	 <75b66ecd0805190916r7ce21667laf19783dfa47cdd7@mail.gmail.com>	 <438397970805190938t195d9a8ejfd5b0ca1409714ab@mail.gmail.com>	 <48328771.4030804@ladisch.de> <438397970805211252u1d228ad8wcb1a6ef9b1251478@mail.gmail.com>
In-Reply-To: <438397970805211252u1d228ad8wcb1a6ef9b1251478@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(please don't top-post!)

Kallol Biswas wrote:
> I am looking at 2.6.25.4 kernel source code. The header file pcm.h
> does not have any definition for supporting IEC 60958 or IEC 61937 frame types.

Almost all S/PDIF transmitters/receivers use SNDRV_PCM_FORMAT_S16.
(Some use S32 for 24-bit samples, but this doesn't matter for
IEC 60958/61937.)

> However, SNDRV_PCM_FMTBIT_IEC958_SUBFRAME is supported.

This is only for some early revisions of the CMI8738 chip which require
software to generate the preamble/channel status/subcode/parity bits
for each subframe.


Regards,
Clemens

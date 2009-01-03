Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbZACAHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbZACAHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 19:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbZACAHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 19:07:23 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:46328 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757698AbZACAHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 19:07:22 -0500
Message-ID: <495EAC36.5030706@blueyonder.co.uk>
Date: Sat, 03 Jan 2009 00:07:18 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-git forcedeth dead interface and nvidia problems
References: <495C4CC0.1040006@blueyonder.co.uk> <40555.1230870755@turing-police.cc.vt.edu>
In-Reply-To: <40555.1230870755@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 01 Jan 2009 04:55:28 GMT, Sid Boyce said:
> 
>> The NVidia driver 180.18 works fine with 2.6.28, but fails with
>> 2.6.28-git. The module builds and installs fine, Xorg.0.log says:-
>> (II) NVIDIA(0): Initialized GPU GART.
>> (II) NVIDIA(0): Setting mode "1280x1024"
>> (EE) NVIDIA(0): Failed to allocate video memory
>> (EE) NVIDIA(0):  *** Aborting ***
>>
>> Fatal server error:
>> AddScreen/ScreenInit failed for driver 0
> 
> A posting on the NVidia forums indicates that booting with 'nopat' or
> building a kernel with CONFIG_X86_PAT=n works.

Thanks, I verified that "nopat" works and I've rebuilt the kernel with
CONFIG_X86_PAT=n waiting for a reboot.
Thanks and Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


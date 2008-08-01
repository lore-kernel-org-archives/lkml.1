Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYHAMVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYHAMVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYHAMVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:21:48 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:9327 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYHAMVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:21:46 -0400
X-BigFish: VPS-11(zz1432R1805Mzz10d3izzz32i6bh8ah43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K4X8ZY-01-JAF-01
Message-ID: <4892FFC1.4060600@amd.com>
Date: Fri, 1 Aug 2008 14:21:21 +0200
From: Peter Oruba <peter.oruba@amd.com>
Organization: AMD (OSRC)
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Max Krasnyansky <maxk@qualcomm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
References: <20080729154103.007575982@amd.com>	 <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>	 <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com> <b647ffbd0808010425r16db2957i3e7212903a698c19@mail.gmail.com>
In-Reply-To: <b647ffbd0808010425r16db2957i3e7212903a698c19@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2008 12:21:21.0534 (UTC) FILETIME=[1B82F1E0:01C8F3D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko schrieb:
> Tigran, Peter,
> 
> 
> may a firmware package contain a few 'microcode' updates for a specific cpu?
> 
> And if so, does each of them provide independent 'errata' fixes? [*]
> 
> (or they are just different versions of the same self-consistent/full
> 'microcode' update and we may need to apply each of them just e.g.
> because we can't jump from stepping X.1 to X.3 without applying X.2 in
> between?
> 
> if it's [1], then I wonder why only a single 'microcode' update (which
> has been previously cached in 'uci->mc') is being applied for the case
> of system-wide resume (apply_microcode_check_cpu()). Don't we need to
> go through the full cpu_request_microcode() cycle to consider all
> updates?
> 
> 
> TIA,
> 

Dmitry,

to answer your question for the AMD part: ucode patches are always 
combo-patches. A ucode patch for a particular CPU revision solves all targeted 
issues at once. There is no case in which two or more ucode patches would be 
applied to a CPU.

Peter

-- 
            |           AMD Saxony Limited Liability Company & Co. KG
  Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
  System    |                  Register Court Dresden: HRA 4896
  Research  |              General Partner authorized to represent:
  Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
            | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYIQTUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYIQTUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYIQTUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:20:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYIQTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:20:03 -0400
Message-ID: <48D1575E.1050306@zytor.com>
Date: Wed, 17 Sep 2008 12:15:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dean Nelson <dcn@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu> <20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu> <20080916204654.GA3532@sgi.com>
In-Reply-To: <20080916204654.GA3532@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dean Nelson wrote:
> 
>     sgi-gru driver
> 
> The GRU is not an actual external device that is connected to an IOAPIC.
> The gru is a hardware mechanism that is embedded in the node controller
> (UV hub) that directly connects to the cpu socket. Any cpu (with permission)
> can do direct loads and stores to the gru. Some of these stores will result
> in an interrupt being sent back to the cpu that did the store.
> 
> The interrupt vector used for this interrupt is not in an IOAPIC. Instead
> it must be loaded into the GRU at boot or driver initialization time.
> 

Could you clarify there: is this one vector number per CPU, or are you 
issuing a specific vector number and just varying the CPU number?

	-hpa

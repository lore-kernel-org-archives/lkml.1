Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbYGQLAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbYGQLAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 07:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbYGQLAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 07:00:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:39442 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYGQK77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 06:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=x5DGBIOSMr4uB8J4H7+F3ZbvFsJrs2Gjr0Sze9NwSk1j1r6+c7GKYnFo+dlElhCXQe
         0B16RbkGhSjH9LdwLFme/OVJtlL8DFvB1YXEzPfBNvXQoT0GiJ1MnTU9CmsqdVzkTxE+
         HMPZ/YmWmfbQYc+622wVJkpVY5Qb0I+XJ2nik=
Message-ID: <487F33F2.2060202@gmail.com>
Date: Thu, 17 Jul 2008 11:58:42 +0000
From: Richard <tuxbox.guru@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080614)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807162156.00983.trenn@suse.de> <487EECDF.1040401@gmail.com> <alpine.LFD.1.10.0807171211310.4316@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807171211310.4316@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> ouch.
>
> I read the whole thread and also checked the suse bugzilla, which
> confuses the hell out of me as there is reported that kubuntu with
> 2.6.24 works and everything suse > 2.6.20 does not.
>
> Can you please tell me the symptoms of vanilla 2.6.25 without nohz=off
> on the kernel command line ?
>
> Thanks,
>
> 	tglx
>
>   
The Short story... it was a dark and rainy night :-P oops, wrong mailing 
list.... so here goes

The kernel boots and when init.d starts, the screen switches off, the 
CPU fan goes to Max speed, and a few minutes later all goes quiet and it 
appears to have powered off.

I usually boot with noapictimer and if I disable ACPI totally, the clock 
references don't work and the timebase goes wrong. (Playing a MP3 is 
quite an entertaining event as it sounds like an old vinyl record player 
with a slipping drive belt)

Richard



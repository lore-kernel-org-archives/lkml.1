Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbYDTTSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbYDTTSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbYDTTSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:18:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbYDTTSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:18:02 -0400
Message-ID: <480B95F4.2010906@zytor.com>
Date: Sun, 20 Apr 2008 15:13:56 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com, Mitch Bradley <wmb@firmworks.com>
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419031024.GC3503@nineveh.local>	<20080418202925.b18452c5.akpm@linux-foundation.org>	<20080419092544.378664a8@ephemeral>	<20080419133909.5aa6b63e@ephemeral>	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>	<480B321B.5020802@zytor.com> <20080420135948.61bdb4c9@ephemeral>
In-Reply-To: <20080420135948.61bdb4c9@ephemeral>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon wrote:
> 
> I'm certainly open to suggestions..  Otherwise, I'll poke around and
> see if I can come up w/ something.
> 

It pretty much depends on what the invariants look like.  The 
normal/clean way of doing this kind of thing is via a fixmap entry 
and/or ioremap.

	-hpa

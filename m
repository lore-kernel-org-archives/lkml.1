Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbYE2TE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbYE2TE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYE2TET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:04:19 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:63064 "EHLO
	outbound9-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbYE2TES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:04:18 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K1N8YK-02-80S-01
Message-ID: <483EFDEA.3010003@amd.com>
Date: Thu, 29 May 2008 14:03:06 -0500
From: Jason Yeh <jason.yeh@amd.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch 1/1] Oprofile Multiplexing
References: <483C6A58.3010008@amd.com> <20080529011035.9e12e5d7.akpm@linux-foundation.org> <20080529122514.GA17191@Krystal>
In-Reply-To: <20080529122514.GA17191@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2008 19:03:06.0556 (UTC) FILETIME=[A0C967C0:01C8C1BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mathieu Desnoyers wrote:
> 
> I have been contemplating the idea of using the performance counters in
> the LTTng kernel tracer for quite a while, but I see the the underlying
> implementations often deal with those counters as if they were
> per-process ressources. Given those ressources are limited amongst the
> whole system, would it make sense to allow an in-kernel consumer to
> connect to some of these counters on a per-CPU basis and return a
> "ressource not available error" to userspace when it tries to connect to
> them ? (and also to kick out a userspace reader when an higher priority
> in-kernel request is done, which implies that the "read" operation may
> fail)
> 

Mathieu,

It sounds like you are asking a re-design of the current Oprofile. I agree
with you that some sort of abstraction are needed for arbitrate who get to
connect the counters. This is probably part of the objectives of the Perfmon2
guys working toward.

The patch is aimed to provide a quick way based on the current
implementation to be able to profile more events than the number of hardware
counters.

Jason


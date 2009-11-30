Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbZK3JZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbZK3JZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZK3JZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:25:32 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:51997 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZK3JZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:25:31 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] sched: Optimize branch hint in context_switch()
Date: Mon, 30 Nov 2009 10:25:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc8-self-00011-ga8a8a66; KDE/4.3.2; i686; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Tim Blechmann <tim@klingt.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <4B1262AC.8000903@klingt.org> <1259508050.13695.160.camel@laptop> <4B129277.5050000@redhat.com>
In-Reply-To: <4B129277.5050000@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911301025.36133.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 29 November 2009 16:25:43 schrieb Avi Kivity:
> These should be documented then to avoid patches removing them:
> 
>       #define slowpath(x) unlikely(x)
> 
>       if (slowpath(condition))
>             expensive_operation();

Neat. If we also modify the likelyhood tracer to __not__ check the
slowpath annotation by default this really looks like a good idea.

Christian

Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbXGQSbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbXGQSbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbXGQSay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:30:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:51558 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423AbXGQSax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:30:53 -0400
Date: Tue, 17 Jul 2007 11:29:44 -0700 (PDT)
From: Jeremy Katz <jeremy.katz@windriver.com>
X-X-Sender: jkatz@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
In-Reply-To: <20070717095707.GB6411@elte.hu>
Message-ID: <Pine.LNX.4.63.0707171109260.10358@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
 <1184662429.12353.426.camel@chaos> <20070717095707.GB6411@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 17 Jul 2007 18:29:44.0958 (UTC) FILETIME=[72CB09E0:01C7C8A0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Ingo Molnar wrote:

> nice one! The race looks pretty narrow - Jeremy, does your Xens have
> hyperthreading? (or are there any heavy SMI sources perhaps that could
> open up this race.) If not then there might be some other bug lurking in
> there as well.

Affirmative.  2 cores, 2 hyperthreading units per.

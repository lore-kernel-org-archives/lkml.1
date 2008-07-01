Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYGALsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYGALsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYGALsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:48:43 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:31386 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYGALsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:48:42 -0400
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: kmemcheck detected possible information leak to userspace?
From: Andi Kleen <andi@firstfloor.org>
References: <19f34abd0807010216k11a60382xf7a27b4b27f0819@mail.gmail.com>
	<20080701102459.GB30248@2ka.mipt.ru>
	<19f34abd0807010352t264fda16g826912a857e88140@mail.gmail.com>
Date: Tue, 01 Jul 2008 13:47:39 +0200
In-Reply-To: <19f34abd0807010352t264fda16g826912a857e88140@mail.gmail.com> (Vegard Nossum's message of "Tue, 1 Jul 2008 12:52:53 +0200")
Message-ID: <87skutu8pw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2008 11:40:18.0787 (UTC) FILETIME=[3CCB5330:01C8DB6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Vegard Nossum" <vegard.nossum@gmail.com> writes:

> But there is one thing I forgot: Is this memory initialized by DMA? If
> so, the warning is bogus and I will go hide in shame.

Yes it is.

[btw that was something I noted during the initial review and was then
ridiculed for]

-Andi

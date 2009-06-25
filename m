Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZFYSbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZFYSbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZFYSbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:31:09 -0400
Received: from fed1rmmtao105.cox.net ([68.230.241.41]:43093 "EHLO
	fed1rmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZFYSbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:31:08 -0400
X-VR-Score: -100.00
X-Authority-Analysis: v=1.0 c=1 a=F_o4wktclTQA:10 a=8zWp4CDmNhVN3as29EUA:9
 a=MVTGGcZhlGhNtarNthw4e9ThxssA:4
X-CM-Score: 0.00
To: Ingo Molnar <mingo@elte.hu>
Cc: Junio C Hamano <gitster@pobox.com>,
       =?utf-8?Q?Ren=C3=A9?= Scharfe <rene.scharfe@lsrfire.ath.cx>,
       roel kluin <roel.kluin@gmail.com>, git@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pierre Habouzit <madcoder@debian.org>
Subject: Re: [PATCH] fread does not return negative on error
References: <4A3FB09D.9050903@gmail.com> <20090622153431.GA18466@elte.hu>
	<25e057c00906220847t15425f38maf486c291d1d2468@mail.gmail.com>
	<4A3FB479.2090902@lsrfire.ath.cx>
	<7vhby64i8f.fsf@alter.siamese.dyndns.org>
	<20090624081819.GA10436@elte.hu>
From: Junio C Hamano <gitster@pobox.com>
In-Reply-To: <20090624081819.GA10436@elte.hu> (Ingo Molnar's message of "Wed\, 24 Jun 2009 10\:18\:19 +0200")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Date: Thu, 25 Jun 2009 11:31:09 -0700
Message-ID: <7vtz24cgia.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> And our general experience with the Git libraries in 
> tools/perf/util/* is: we love them!

> For example parse-options.c is a striking improvement compared to 
> getopt.h we used before, and all the other facilities are sane and 
> straight to the point as well. So in this sense 'perf' is an ... 
> interesting cross-discipline 'fork' of Git's generic libraries.

Kudos to Pierre, then.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbZLGHKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbZLGHKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbZLGHKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:10:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55453 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866AbZLGHKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:10:13 -0500
Date: Mon, 7 Dec 2009 08:10:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@redhat.com>
Cc: a.p.zijlstra@chello.nl, fweisbec@gmail.com, jaswinderrajput@gmail.com,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: Minor optimization in parse_subsystem_tracepoint_event
Message-ID: <20091207071008.GE10868@elte.hu>
References: <200912061825.nB6IPUa1023306@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912061825.nB6IPUa1023306@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ulrich Drepper <drepper@redhat.com> wrote:

> Uses of strcat are almost always signs that someone is too lazy to think
> about the code a bit more carefully.  One always has to know about the
> lengths of the strings involved to avoid buffer overflows.
> 
> This is one case where the size of the object code for me is reduced by
> 38 bytes.  The code should also be faster, especially if flags is non-NULL.
> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

Applied, thanks a lot Ulrich!

	Ingo

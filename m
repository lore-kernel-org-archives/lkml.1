Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZJTE0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZJTE0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZJTE0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:26:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:35998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZJTE0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:26:51 -0400
Subject: Re: pref record question
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <4ADC9C2A.5020707@klingt.org>
References: <4ADC9C2A.5020707@klingt.org>
Content-Type: text/plain
Date: Tue, 20 Oct 2009 06:26:50 +0200
Message-Id: <1256012810.17774.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 19:04 +0200, Tim Blechmann wrote:
> i am trying to do some profiling with perf (2.6.31.4). while
> thread-level profiling works fine, i haven't been able to record
> profiling data of a whole process (i.e. main thread + child threads).
> from my understanding, this should be enabled by running 'perf record
> -i' on the main thread. this does only collect the data from the main
> thread, though.
> 
> is this an issue with perf or with my understanding of perf?

-i will only inherit the counters on new fork()/clone() calls, so an
existing process/task tree will not automagically get the counters.


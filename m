Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYIOJPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYIOJPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 05:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYIOJPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 05:15:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47316 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYIOJPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 05:15:39 -0400
Subject: Re: [PATCH] sysfs: fix deadlock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080914220208.GF27080@wotan.suse.de>
References: <20080910113717.GB16811@wotan.suse.de>
	 <1221046892.30429.85.camel@twins.programming.kicks-ass.net>
	 <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu>
	 <20080910144812.GB18644@wotan.suse.de>
	 <1221058864.30429.291.camel@twins.programming.kicks-ass.net>
	 <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu>
	 <20080911104323.GB23775@wotan.suse.de> <20080912092411.GB10305@elte.hu>
	 <20080914220208.GF27080@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 11:15:08 +0200
Message-Id: <1221470108.7351.0.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-15 at 00:02 +0200, Nick Piggin wrote:

> Well thanks to Peter as well. Actually I don't suppose this will throw
> off the lockstat statistics a bit? (although I guess serious lockstat
> profiling might not have prove locking turned on?).

It will actually - /me cribs it on his todo-when-getting-back-home list.


Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZHCOXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZHCOXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZHCOXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:23:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:47966 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbZHCOXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:23:23 -0400
Date: Mon, 3 Aug 2009 07:25:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
Message-ID: <20090803072522.1d90f15c@infradead.org>
In-Reply-To: <20090803112220.GA22936@elte.hu>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
	<20090803112220.GA22936@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009 13:22:20 +0200
Ingo Molnar <mingo@elte.hu> wrote:
> 
> This new oprofile multiplexing mechanism really overlaps the PMU 
> abstractions that perfcounters already provide, and i disagree with 
> this general direction. The code you wrote is clean though so i've 

is there any way thast the oprofole interfaces can be written on top
of the low level perf infrastructure?

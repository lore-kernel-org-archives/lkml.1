Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbYAVQia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbYAVQia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbYAVQiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:38:10 -0500
Received: from waste.org ([66.93.16.53]:51516 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbYAVQiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:38:08 -0500
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080122143912.GJ7304@elte.hu>
References: <20080118110252.GA17397@elte.hu>
	 <47909821.1090907@free-electrons.com> <20080118122540.GH11044@elte.hu>
	 <20080118122926.GA15216@elte.hu> <4790A385.800@free-electrons.com>
	 <1200664214.4001.24.camel@cinder.waste.org>
	 <4790D3E3.4060409@free-electrons.com>
	 <1200676219.3835.8.camel@cinder.waste.org> <20080118210938.GE10717@elte.hu>
	 <1200695950.25782.28.camel@cinder.waste.org>
	 <20080122143912.GJ7304@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 10:37:19 -0600
Message-Id: <1201019839.14436.30.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 15:39 +0100, Ingo Molnar wrote:
> threadinfo-ool.patch: doesnt this break the scheduler? 

It didn't when I wrote it, 3+ years ago. But I'm sure it needs to be
revisited.

> tiny-cflags.patch: obsolete? Isnt CFLAGS already extendable? Question to 
> Sam i guess.

Yup.

-- 
Mathematics is the supreme nostalgia of our time.


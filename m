Return-Path: <linux-kernel-owner+w=401wt.eu-S933395AbXGLMl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbXGLMl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXGLMlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:41:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42795 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509AbXGLMlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:41:21 -0400
Subject: Re: NPTL
From: Peter Zijlstra <peterz@infradead.org>
To: "Ni@m" <niam.niam@gmail.com>
Cc: davids@webmaster.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a9e22dff0707120537l1a29de93vdd67f146cf36a120@mail.gmail.com>
References: <a9e22dff0707120518t77d440d3ue0368fd1f3e36c03@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKCEOCFDAC.davids@webmaster.com>
	 <a9e22dff0707120537l1a29de93vdd67f146cf36a120@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 14:41:18 +0200
Message-Id: <1184244078.20032.48.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 15:37 +0300, Ni@m wrote:
> So I can say that in linux 'thread' == 'process'?

No, a process also contains an address space.

> Is kernel routine 'kthread' creating a process?

No, that is creating a schedule unit (task) without an address space.

> I'm just thinking on this subject: if to create 'real threads' - will
> it increase performance? Should I ever think in this way?
> When I say 'real thread' - I mean the thread that doen't switch
> context when it's starting to run.

Surely you need some context switch when switching between runnable
contexts.

BTW, please do _NOT_ top post!



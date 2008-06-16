Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYFPTRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYFPTRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYFPTRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:17:43 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:41056 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbYFPTRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:17:42 -0400
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize non-migratable
	tasks over migratable ones"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
References: <1213138710.26530.51.camel@earth>
	 <1213174382.31518.69.camel@twins>
	 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
	 <48563FDB.BA47.005A.0@novell.com>
	 <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 21:17:42 +0200
Message-Id: <1213643862.16944.142.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 19:59 +0200, Dmitry Adamushko wrote:

> One way or another, we have different aritifacts (and mine have likely
> more) but conceptually, both "violates" POSIX if a strict round-robin
> scheduling is required.

http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html#tag_02_08_04_01

Is quite strict on what FIFO should do, and I know of two points where
we deviate and should work to match.


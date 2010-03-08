Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0CHDvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 22:51:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58934 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab0CHDvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 22:51:44 -0500
Date: Mon, 8 Mar 2010 04:51:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Paul Mackerras <paulus@samba.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
Message-ID: <20100308035143.GE20695@one.firstfloor.org>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com> <20090803112220.GA22936@elte.hu> <20090803072522.1d90f15c@infradead.org> <20090804201109.GA21386@elte.hu> <20090805123501.GF14610@erda.amd.com> <84144f020908060031vb48b983m6e6b1b521e01d6aa@mail.gmail.com> <20090806105134.GD11236__37984.4768475325$1249556453$gmane$org@elte.hu> <87ocjcqcdj.fsf@basil.nowhere.org> <20100305164615.GY13205@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305164615.GY13205@erda.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the tests I run with oprofile do not indicate unreliable ring_buffer

Did you try it with callgraph mode? That seems to be worst.

> behavior. Maybe my use cases and loads are different. Can you describe
> a setup where this may happen for sure? What is the impact, do you

Seeing it on very busy 16 CPU and larger systems.

> have lost samples or inconsistent buffer data? Is the data loss in

There are a lot of lost samples, callgraphs are incomplete etc.

> kernel or user space? Also, I am not aware that the ring_buffer is

Not sure.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

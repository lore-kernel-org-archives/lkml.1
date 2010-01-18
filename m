Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157Ab0ARQeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0ARQeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878Ab0ARQeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:34:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab0ARQd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:33:59 -0500
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joshua Pincus <joshua.pincus@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com>
	<87ljg1fn3u.fsf@basil.nowhere.org>
	<bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com>
	<20100114092350.GF12241@basil.fritz.box>
	<bc915a051001141003s766689beue73800a1308d957e@mail.gmail.com>
	<20100118110406.GC5256@nowhere>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 18 Jan 2010 11:33:46 -0500
In-Reply-To: <20100118110406.GC5256@nowhere> (Frederic Weisbecker's message of "Mon, 18 Jan 2010 12:04:07 +0100")
Message-ID: <y0maawbid91.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> [...]
> What about extending ptrace to support a new type of
> breakpoint debugging interface?

This is the sort of reason why the utrace-gdbstub prototype was
constructed.  It should allow in-kernel implementation of the
multithreaded gdb extensions.  (By the way, it can already use uprobes
rather than userspace-managed breakpoints.)

- FChE

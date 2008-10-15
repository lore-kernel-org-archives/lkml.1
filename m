Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYJOWqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYJOWqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYJOWqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:46:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48153 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYJOWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:46:14 -0400
Date: Wed, 15 Oct 2008 18:46:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, gregkh@suse.de,
       jesse.brandeburg@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -stable] disable CONFIG_DYNAMIC_FTRACE due to possible
 memory corruption on module unload
In-Reply-To: <alpine.DEB.1.10.0810151815110.18960@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810151843130.19408@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810151815110.18960@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 15 Oct 2008, Steven Rostedt wrote:
> 
> The problem arises when we trace functions and modules are unloaded.

Note, it is not just module unloading. The issue can happen when the
init functions of a module are freed and the nvram is vmapped there as
well.

-- Steve

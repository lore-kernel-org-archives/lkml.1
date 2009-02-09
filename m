Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbZBIOLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbZBIOLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbZBIOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:10:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57697 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbZBIOKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:10:44 -0500
Date: Mon, 9 Feb 2009 09:10:42 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
cc: mingo@elte.hu, fweisbec@gmail.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] splice patches for ftrace
In-Reply-To: <cover.1234159200.git.eduard.munteanu@linux360.ro>
Message-ID: <alpine.DEB.1.10.0902090907190.14528@gandalf.stny.rr.com>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 9 Feb 2009, Eduard - Gabriel Munteanu wrote:

> Hi,
> 
> This implements splice support so we can use it in kmemtrace-user. Please
> check it out and tell me what you think.
> 
> The "RFC" in the subject reads like "I tested this the best I could,
> although kmemtrace-user isn't still ready.". As we speak, I'm working on
> making kmemtrace over ftrace and kmemtrace-user work together nicely.

Hi Eduard!

Thanks, I'll give it a test. I've been playing on my spare time with
a ring buffer splice interface. But I've not had the time to get it 
working fully. My version would be a binary only interface, but I really 
like the text interface you have.

You can look at my old changes at:

 git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

  The branch tip/splice-broken

As the name suggests, it is still broken ;-)

-- Steve


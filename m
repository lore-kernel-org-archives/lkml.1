Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZIUQJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZIUQJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZIUQJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:09:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbZIUQJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:09:15 -0400
Date: Mon, 21 Sep 2009 09:08:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@lst.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT PULL] tracing fixes
In-Reply-To: <20090921130228.GA25588@elte.hu>
Message-ID: <alpine.LFD.2.01.0909210908020.4950@localhost.localdomain>
References: <20090921130228.GA25588@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Sep 2009, Ingo Molnar wrote:
> 
> Christoph Hellwig (1):
>       tracing: Remove markers

This seems to result in:

	kernel/module.c:2951: warning: ¡struct marker¢ declared inside parameter list
	kernel/module.c:2951: warning: its scope is only this definition or declaration, which is probably not what you want

Hmm? Incomplete removal?

		Linus

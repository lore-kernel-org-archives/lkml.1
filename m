Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbZEAQdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbZEAQdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZEAQcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:32:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZEAQcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:32:51 -0400
Date: Fri, 1 May 2009 12:32:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter
 atomic
In-Reply-To: <alpine.DEB.2.00.0905011230350.20374@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0905011232330.20374@gandalf.stny.rr.com>
References: <20090501022210.851418183@goodmis.org> <20090501022403.826182932@goodmis.org> <20090501115047.GA24706@elte.hu> <alpine.DEB.2.00.0905011016560.20374@gandalf.stny.rr.com> <alpine.DEB.2.00.0905011212130.20374@gandalf.stny.rr.com> <20090501162053.GA17915@elte.hu>
 <alpine.DEB.2.00.0905011230350.20374@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 May 2009, Steven Rostedt wrote:
> A writer can subtract them if it overwrites a page before the producer 
> consumes it.

s/producer/consumer/

-- Steve


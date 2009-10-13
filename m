Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbZJMJRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbZJMJRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbZJMJRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:17:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:53649 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZJMJRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:17:10 -0400
Subject: Re: [PATCH 3/4] tracing/profile: Add filter support
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AD3E3B5.70502@cn.fujitsu.com>
References: <4AD3E34C.1020301@cn.fujitsu.com>
	 <4AD3E3B5.70502@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Oct 2009 11:16:17 +0200
Message-Id: <1255425377.8392.156.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 10:19 +0800, Li Zefan wrote:
> +#ifdef CONFIG_EVENT_PROFILE
> +       struct event_filter             *filter;
> +       int                             filter_active;
>  #endif

Why do you need filter_active, isn't !filter equivalent?

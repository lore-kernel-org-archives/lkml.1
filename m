Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbYGPQAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbYGPQAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbYGPQAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:00:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53828 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbYGPQAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:00:32 -0400
Date: Thu, 17 Jul 2008 00:50:33 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 10/17] LTTng instrumentation - swap
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       linux-mm@kvack.org, Dave Hansen <haveblue@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
In-Reply-To: <20080716150046.GI24546@Krystal>
References: <1216219654.5232.55.camel@twins> <20080716150046.GI24546@Krystal>
Message-Id: <20080717004734.1579.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > Would it make more sense to turn get_swap_info_struct into a static
> > > inline in swap.h ?
> > 
> > Seeing a consumer of it would go a long way towards discussing it ;-)
> 
> The LTTng probe which connects to this tracepoint looks like :

I have no objection to this exporting.

However, This is LTTng requirement.
but tracepoint is tracer independent mechanism.
then, split out is better IMHO.





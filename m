Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZLBA1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZLBA1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZLBA1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:27:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33270 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbZLBA1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:27:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm: Introduce coredump parameter structure
Cc: kosaki.motohiro@jp.fujitsu.com, Masami Hiramatsu <mhiramat@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, hidehiro.kawai.ez@hitachi.com, lethal@linux-sh.org,
       mingo@elte.hu, roland@redhat.com, vapier@gentoo.org,
       Takahiro Yasui <tyasui@redhat.com>
In-Reply-To: <20091201161800.fa6b6ae4.akpm@linux-foundation.org>
References: <4B11FB6F.4040403@redhat.com> <20091201161800.fa6b6ae4.akpm@linux-foundation.org>
Message-Id: <20091202092607.5C40.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Dec 2009 09:27:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 28 Nov 2009 23:41:19 -0500
> Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Introduce coredump parameter data structure (struct coredump_params)
> > for simplifying binfmt->core_dump() arguments.
> > 
> > Changes in v2:
> >    - Don't remove DUMP_WRITE() macro.
> 
> What is the reason for this change?
> 
> Please always include both the "what" and the "why" in changelog text.

I reported v1 break ia64 and uml. its arch specific code still use DUMP_WRITE().

Thanks.



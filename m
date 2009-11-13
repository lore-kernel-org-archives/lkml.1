Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZKMJK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZKMJK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbZKMJKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:10:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbZKMJKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:10:21 -0500
Subject: Re: [PATCH] tracing: Rename lockdep event subsystem into lock
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1258103194-843-1-git-send-email-fweisbec@gmail.com>
References: <20091113085123.GA1318@elte.hu>
	 <1258103194-843-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 10:10:09 +0100
Message-ID: <1258103409.4039.1079.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 10:06 +0100, Frederic Weisbecker wrote:
> Lockdep events subsystem gathers various locking related events such
> as a request, release, contention or acquisition of a lock.
> 
> The name of this event subsystem is a bit of a misnomer since these
> events are not quite related to lockdep but more generally to locking,
> ie: these events are not reporting lock dependencies or possible
> deadlock scenario but pure locking events.

But in order to get them you need pretty much all of lockdep, except
PROVE_LOCKING. You get all the lock debugging, the lock tracking, the
struct dep_map bloat etc.

But sure, I don't mind renaming the category.


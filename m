Return-Path: <linux-kernel-owner+w=401wt.eu-S932721AbZJHQ37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbZJHQ37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 12:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758737AbZJHQ37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 12:29:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662AbZJHQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:29:58 -0400
Subject: Re: [PATCH] perf tools: Improve thread comm resolution in perf
 sched
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1255012632-7882-1-git-send-email-fweisbec@gmail.com>
References: <1255012632-7882-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Oct 2009 18:33:02 +0200
Message-Id: <1255019582.26976.314.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 16:37 +0200, Frederic Weisbecker wrote:
> When we get sched traces that involve a task that was already
> created before opening the event, we won't have the comm event
> for it.

pid_synthesize_comm_event() should have taken care of that..

> So if we can't find the comm event for a given thread, we look at the
> traces that may contain these informations.

Sure, but it would be good to find out why the synthesize bits didn't
work as expected.

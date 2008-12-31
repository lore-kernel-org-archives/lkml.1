Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYLaPmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYLaPmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 10:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbYLaPlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 10:41:52 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:40579 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbYLaPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 10:41:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=T1TcLJFvxPM63NIxEcKA0QPudC/a44h1z/BCh5LIhut4P6HFB1X29jjXWokz9zXw7m
         jdl0rw5pJJpXZRNjQc8agvByu+O2VoTz3u321+9k/fXPXtBJwX22ctuT0lFerMjUTxuA
         3Xp4BYztqL2bKcX1VQwVx+zZkwSDWDe1bFdUY=
Date: Wed, 31 Dec 2008 16:41:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       fweisbec@gmail.com
Subject: [PATCH 0/2] tracing/stat handling updates
Message-ID: <20081231154147.GB5748@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a quick look on the need of stats tracers, it looks like it is often
needed to have several stat modes/files for a single tracer.

The current tracing stat API doesn't support more than one stat file per tracer.

The first patch makes the tracing/stat Api reentrant and let a tracer able
implement more than one stat file.

The second one adapts this Api to the branch tracer.

 kernel/trace/trace.h        |   35 ++++---
 kernel/trace/trace_branch.c |   69 +++++--------
 kernel/trace/trace_stat.c   |  229 +++++++++++++++++++++++++++++++------------
 3 files changed, 216 insertions(+), 117 deletions(-)



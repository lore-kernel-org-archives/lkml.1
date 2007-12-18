Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbXLRL35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbXLRL35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 06:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXLRL3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 06:29:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbXLRL3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:29:49 -0500
Date: Tue, 18 Dec 2007 03:28:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>, Gautham R Shenoy <ego@in.ibm.com>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH] sched: dynamically update the root-domain span/online
 maps
Message-Id: <20071218032812.cbb6c823.akpm@linux-foundation.org>
In-Reply-To: <20071218104800.GC29466@elte.hu>
References: <200712172339.lBHNdmDD008149@imap1.linux-foundation.org>
	<20071218005217.4957.3055.stgit@novell1.haskins.net>
	<20071218104800.GC29466@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 11:48:00 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
> > http://marc.info/?l=linux-mm-commits&m=119793598429477&w=2
> > 
> > I have confirmed that it builds and boots clean, and it passes 
> > checkpatch. However, my test machine seems to be having problems with 
> > suspend-to-ram that are unrelated to this patch that prevent me from 
> > verifying the fix entirely. If Gautham or Andrew could confirm that it 
> > resolves their suspend-to-ram issue, I would be most appreciative.
> 
> i'm reluctant to apply it without test results, unless we have a very 
> clear picture of what happened on Andrew's box and how this updated 
> patch resolves that problem. (or once Andrew tests your patch and deems 
> it OK.)
> 

<wades through a pile of new compile errors>

<tests it>

Seems OK now - resume-from-RAM actually resumes.

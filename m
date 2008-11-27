Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYK0K6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYK0K6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbYK0KzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:55:10 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:3182 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbYK0KzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:55:08 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
 trace output
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081127103424.GA9132@elte.hu>
References: <492DEDE9.9010109@gmail.com>  <20081127103424.GA9132@elte.hu>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 11:55:00 +0100
Message-Id: <1227783300.4454.1410.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 11:34 +0100, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Here is an example of the new output:
> > 

> > CPU[000]  ------------8<---------- thread bash-2794 ------------8<----------

This is the most horrid thing I've ever seen.

Please just put the comm/pid in another left column and leave a plain
"---" string for context switches.

comm/pid only in the separator is useless, you cannot grep stuff like
that, also, what's up with those '8's ?


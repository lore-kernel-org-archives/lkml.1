Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbXJXAXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbXJXAXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 20:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbXJXAX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 20:23:28 -0400
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:59279 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbXJXAX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 20:23:26 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 13/13] RT: Cache cpus_allowed weight for optimizing migration
Date: Wed, 24 Oct 2007 02:19:23 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
References: <20071023164156.5536.95573.stgit@novell1.haskins.net> <20071023165130.5536.73345.stgit@novell1.haskins.net>
In-Reply-To: <20071023165130.5536.73345.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710240219.25487.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

On Tuesday 23 October 2007, Gregory Haskins wrote:
> Calculating the weight is probably relatively expensive, so it is only
> done when the cpus_allowed mask is updated (which should be relatively
> infrequent, especially compared to scheduling frequency) and cached in
> the task_struct.

Why not make it a task flag, since according to your code, you are only 
interested whether this is <= 1 or > 1. Since !(x <= 1) <=> (x > 1)
for any given unsigned integer x, the required data structure is
a "boolean" or a flag.


Best Regards

Ingo Oeser

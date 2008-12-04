Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYLDFwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYLDFwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYLDFw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:52:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:38038 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYLDFw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:52:27 -0500
Message-ID: <49376BFE.2010501@windriver.com>
Date: Thu, 04 Dec 2008 13:34:54 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
References: <20081204052638.425740534@goodmis.org> <20081204052735.362609481@goodmis.org>
In-Reply-To: <20081204052735.362609481@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Dec 2008 05:51:33.0911 (UTC) FILETIME=[5D09A270:01C955D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
 > /* set when tracing only a pid */
 > struct pid *ftrace_pid_trace;
 >+static struct pid * const ftrace_swapper_pid = (struct pid *)1;

swapper pid is 1? not 0?


Liming Wang

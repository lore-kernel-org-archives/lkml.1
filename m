Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbYJVT3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbYJVT3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYJVT3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:29:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbYJVT3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:29:05 -0400
Date: Wed, 22 Oct 2008 12:27:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       sagar.abhishek@gmail.com, davem@davemloft.net, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 05/11] ftrace: only have ftrace_kill atomic
Message-Id: <20081022122750.e7860186.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0810221516410.25759@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org>
	<20081022185136.312667539@goodmis.org>
	<20081022121128.5acc9ae0.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0810221516410.25759@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 15:18:39 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> What's your preference fo a name of a function that should completely 
> disable ftrace on anomaly detection?  Unfortunately, ftrace_stop, 
> ftrace_disable, and ftrace_shutdown are already in use.

ftrace_kill()?  ftrace_akpm()?

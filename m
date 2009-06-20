Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbZFTWUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbZFTWUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 18:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZFTWUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 18:20:23 -0400
Received: from vena.lwn.net ([206.168.112.25]:55860 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408AbZFTWUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:20:23 -0400
Date: Sat, 20 Jun 2009 16:20:23 -0600
From: Jake Edge <jake@lwn.net>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       jake@lwn.net, rostedt@goodmis.org, srostedt@redhat.com,
       tglx@linutronix.de
Subject: Re: [tip:tracing/urgent] function-graph: disable when both x86_32
 and optimize for size are configured
Message-ID: <20090620162023.3fdd10ae@chukar>
In-Reply-To: <tip-eb4a03780d4c4464ef2ad86d80cca3f3284fe81d@git.kernel.org>
References: <tip-eb4a03780d4c4464ef2ad86d80cca3f3284fe81d@git.kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009 16:43:44 GMT tip-bot for Steven Rostedt wrote:
> Commit-ID:  eb4a03780d4c4464ef2ad86d80cca3f3284fe81d
> Gitweb:
> http://git.kernel.org/tip/eb4a03780d4c4464ef2ad86d80cca3f3284fe81d
> Author:     Steven Rostedt <srostedt@redhat.com> AuthorDate: Thu, 18
> Jun 2009 12:53:21 -0400 Committer:  Steven Rostedt
> <rostedt@goodmis.org> CommitDate: Thu, 18 Jun 2009 18:39:30 -0400

I applied the patch, turned off 'Optimize for size', rebuilt, booted,
and all was well (with the function_graph tracer selftest anyway) ..
the sysprof tracer still consistently fails: .. no entries
found ..FAILED!

Tested-by: Jake Edge <jake@lwn.net>
> Reported-by: Jake Edge <jake@lwn.net>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net

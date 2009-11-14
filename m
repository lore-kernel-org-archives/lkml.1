Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbZKNF0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbZKNF0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 00:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZKNF0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 00:26:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbZKNF0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 00:26:51 -0500
Date: Fri, 13 Nov 2009 21:26:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: rostedt@goodmis.org
Cc: lihong.hi@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: + recordmcount-stfu.patch added to -mm tree
Message-Id: <20091113212645.3956bc85.akpm@linux-foundation.org>
In-Reply-To: <1258174705.22249.236.camel@gandalf.stny.rr.com>
References: <200911140356.nAE3utfU001939@imap1.linux-foundation.org>
	<1258174705.22249.236.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009 23:58:25 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> ...
>
> Andrew, would something like this patch be sufficient?
> 
> ...
>
> +	    "\tLocal function references are disabled.\n" .
> +	    "\tTo disable this message, create the file FTRACE_QUIET\n" .
> +	    "\tin the top level directory\n";

Dunno, really.  How many people are running old objdump, and do we want
to retard the rate at which the stragglers will upgrade?

I tend to be a late adopter ;) (for legit reasons, really - to catch
things like this) so I'd be OK carrying that patch locally.


Emitting that warning 1000000000000000000000000000 times per build is a
bit obnoxious.  Maybe find some way to restrict it to once per `make'?


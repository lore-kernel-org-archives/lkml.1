Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140Ab0ARHXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0ARHXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151Ab0ARHXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:23:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:35900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0ARHXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:23:43 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100116184833.2s0zihwbggkgccsk@imap.linux.ibm.com>
References: <20100116184833.2s0zihwbggkgccsk@imap.linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 08:23:17 +0100
Message-ID: <1263799397.4283.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-16 at 18:48 -0500, Jim Keniston wrote:

> As you may have noted before, I think FP would be a special problem  
> for your approach.  I'm not sure how folks would react to the idea of  
> executing FP instructions in kernel space.  But emulating them is also  
> tough.  There's an IEEE FP emulation package somewhere in one of the  
> Linux arch directories, but I'm not sure how precise it is, and  
> dropping even 1 bit of precision is unacceptable for many  
> applications, since such errors tend to grow in complex computations  
> employing many FP instructions.

Well, we have kernel space using FP/MMX/SSE like things, its not hard if
you really need it, but in this case I think its easier than normal,
because we'll just allow it to change the userspace state because that
is exactly what we want it to do.


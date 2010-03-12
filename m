Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab0CLN1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:27:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:36003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab0CLN1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:27:37 -0500
Date: Fri, 12 Mar 2010 10:27:18 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2 5/5] perf report: Initial TUI using newt
Message-ID: <20100312132718.GO14180@ghostprotocols.net>
References: <1268349164-5822-1-git-send-email-acme@infradead.org> <1268349164-5822-5-git-send-email-acme@infradead.org> <20100312094533.GA13177@elte.hu> <4B9A0F78.7020201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9A0F78.7020201@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 12, 2010 at 11:55:04AM +0200, Avi Kivity escreveu:
> On 03/12/2010 11:45 AM, Ingo Molnar wrote:
>>
>>   - When i hit enter on a symbol to annotate it, but the annotation fails, the TUI
>>     just does nothing currently. Instead it should print something informative
>>     (and eye-catching) into a status line at the top or the bottom of the
>>     screen, possibly printed in red characters or so. Not a separate window as that
>>     needs extra key-hits to get rid of - just a sufficiently visible status
>>     line would be perfect. There can be a few reasons why some functions can be
>>     annotated while others cannot be.
>
> Alternatively, mark it as unannotatable in the first place (e.g. an  
> annotatable symbol is a hyperlink, an unannotatable one is not).  But  
> perhaps that's too computationally expensive.

I'll come up with some way to do that, changing the color or adding
markings to highlight the top functions, like the stdio one does with
red for te top functions, etc is needed.

- Arnaldo

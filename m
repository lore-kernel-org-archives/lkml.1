Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0CLJzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:55:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab0CLJzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:55:37 -0500
Message-ID: <4B9A0F78.7020201@redhat.com>
Date: Fri, 12 Mar 2010 11:55:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2 5/5] perf report: Initial TUI using newt
References: <1268349164-5822-1-git-send-email-acme@infradead.org> <1268349164-5822-5-git-send-email-acme@infradead.org> <20100312094533.GA13177@elte.hu>
In-Reply-To: <20100312094533.GA13177@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 11:45 AM, Ingo Molnar wrote:
>
>   - When i hit enter on a symbol to annotate it, but the annotation fails, the TUI
>     just does nothing currently. Instead it should print something informative
>     (and eye-catching) into a status line at the top or the bottom of the
>     screen, possibly printed in red characters or so. Not a separate window as that
>     needs extra key-hits to get rid of - just a sufficiently visible status
>     line would be perfect. There can be a few reasons why some functions can be
>     annotated while others cannot be.
>    

Alternatively, mark it as unannotatable in the first place (e.g. an 
annotatable symbol is a hyperlink, an unannotatable one is not).  But 
perhaps that's too computationally expensive.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


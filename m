Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0BDUhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:37:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab0BDUht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:37:49 -0500
Message-ID: <4B6B2FF5.6040706@redhat.com>
Date: Thu, 04 Feb 2010 15:37:09 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jason Baron <jbaron@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/4] kprobes updates
References: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com> <20100204090626.GA30663@elte.hu>
In-Reply-To: <20100204090626.GA30663@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> FYI, there's this new build warning on x86 defconfig:
> 
> arch/x86/kernel/alternative.c: In function 'alternatives_text_reserved':
> arch/x86/kernel/alternative.c:402: warning: comparison of distinct pointer types lacks a cast
> arch/x86/kernel/alternative.c:402: warning: comparison of distinct pointer types lacks a cast
> arch/x86/kernel/alternative.c:405: warning: comparison of distinct pointer types lacks a cast
> arch/x86/kernel/alternative.c:405: warning: comparison of distinct pointer types lacks a cast
> 
> Caused by:
> 
> 2cfa197: ftrace/alternatives: Introducing *_text_reserved functions

Oops, thanks. I'll fix it in next patches.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


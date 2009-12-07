Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbZLGPAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbZLGPAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbZLGPAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:00:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:55443 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbZLGPAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:00:41 -0500
Date: Mon, 7 Dec 2009 07:02:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] tracing/power: Remove two exports
Message-ID: <20091207070251.6f5d64c6@infradead.org>
In-Reply-To: <4B1CB253.3000204@cn.fujitsu.com>
References: <4B1CB14A.4080402@cn.fujitsu.com>
	<4B1CB253.3000204@cn.fujitsu.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Dec 2009 15:44:19 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> trace_power_start and trace_power_end are only used in
> arch/x86/kernel/power.c, and this file can't be compiled
> as a module, so these two tracepoints needn't to be exported.
> 

they were originally exported if some other arch wanted to use them
modular... since nobody does

Acked-by: Arjan van de Ven <arjan@linux.intel.com>


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

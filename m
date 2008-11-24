Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbYKXLG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbYKXLG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 06:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYKXLGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 06:06:30 -0500
Received: from ns2.suse.de ([195.135.220.15]:39597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYKXLGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 06:06:30 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] kreplace: Rebootless kernel updates
Date: Mon, 24 Nov 2008 16:37:32 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, davem@davemloft.net,
       contact@ksplice.com, jbarnold@ksplice.com, tabbott@ksplice.com,
       wdaher@ksplice.com, andersk@ksplice.com
References: <200811211720.26394.knikanth@suse.de> <4926C838.8080105@redhat.com>
In-Reply-To: <4926C838.8080105@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811241637.33329.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2008 20:09:52 Masami Hiramatsu wrote:
> Hi Nikanth,
>
> Nikanth Karthikesan wrote:

> Hmm,
> Would you like to replace a function to another function?
> If so, AFAIK, you can do that with kprobe and below pre_handler.
> (see booster enabled path in setup_singlestep())
>
> pre_handler(...)
> {
> 	reset_current_kprobe();	/* this kprobe doesn't need any more */
> 	regs->ip = new_function;	/* change IP to new function */
> 	preempt_enable_no_resched();	/* recover preempt count */
> 	return 1;	/* No need to setup singlestep */
> }
>
>

So, am I seeing worries to enable something, which is already possible, but 
just not documented?

Thanks
Nikanth Karthikesan




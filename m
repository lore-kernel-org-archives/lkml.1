Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZLIOGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZLIOGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZLIOGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:06:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36878 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbZLIOGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:06:36 -0500
X-Authority-Analysis: v=1.0 c=1 a=sHHlHcWDpqoA:10 a=7U3hwN5JcxgA:10 a=3ZxrLodb3BXVXqoVcZUA:9 a=-CL_Veea-WmgSoNexZAA:7 a=FxiPLT8fH3J_ZUSixXJ-ZZSvQ1EA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][GIT PULL][v2.6.33] tracing: Remove comparing of NULL
 to va_list in trace_array_vprintk()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Carsten Emde <Carsten.Emde@osadl.org>,
       Olof Johansson <olof@lixom.net>, hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <20091209061528.GA26687@elte.hu>
References: <4B01AE5D.1010801@osadl.org>
	 <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org>
	 <20091206051352.GA4628@lixom.net> <4B1BAB74.104@osadl.org>
	 <1260332397.2146.38.camel@gandalf.stny.rr.com>
	 <20091209055602.GB2512@elte.hu> <20091209061148.GA14010@elte.hu>
	 <20091209061528.GA26687@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 09 Dec 2009 09:06:40 -0500
Message-ID: <1260367600.2146.69.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 07:15 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> >  efcf61a: tracing: Remove comparing of NULL to va_list in trace_array_vprintk()
> 
> the real culprit was:
> 
>   6e0573f: tracing: Buffer the output of seq_file in case of filled buffer
> 
> so i kept this commit:
> 
>   c521efd: tracing: Add pipe_close interface
> 
> and skipped the rest for now - please resend if this is fixed.
> 

I'll get this fixed today.

Thanks!

-- Steve



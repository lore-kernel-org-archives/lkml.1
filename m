Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZKQOSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZKQOSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZKQOSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:18:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZKQOSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:18:15 -0500
Subject: Re: [PATCH] ftrace: fix trace_marker output
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Carsten Emde <Carsten.Emde@osadl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B01AE5D.1010801@osadl.org>
References: <4B01AE5D.1010801@osadl.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 17 Nov 2009 09:18:20 -0500
Message-Id: <1258467500.22249.460.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 20:56 +0100, Carsten Emde wrote:
>  
> @@ -1408,7 +1409,7 @@ int trace_array_vprintk(struct trace_arr
>  
>  int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
>  {
> -	return trace_array_printk(&global_trace, ip, fmt, args);
> +	return trace_array_vprintk(&global_trace, ip, fmt, args);
>  }
>  EXPORT_SYMBOL_GPL(trace_vprintk);

Applying the patch, I found that this part is already fixed upstream.
But I'll add the rest of your patch since it does have other fixes.

Thanks,

-- Steve



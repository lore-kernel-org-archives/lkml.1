Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZLJDrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZLJDrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 22:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759507AbZLJDrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 22:47:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54188 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503AbZLJDrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 22:47:15 -0500
X-Authority-Analysis: v=1.0 c=1 a=wwKGpBRrS64A:10 a=7U3hwN5JcxgA:10 a=M-0wt-D9OPoUorKoyE8A:9 a=-k5V_2njcw_4rpTol34A:7 a=LczRvGrb9WosvrWtlKGAwOEBFioA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 4/4] ftrace - function_duration Documentation
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B2027C7.9010509@am.sony.com>
References: <4B2027C7.9010509@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 09 Dec 2009 22:47:20 -0500
Message-ID: <1260416840.2146.134.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 14:42 -0800, Tim Bird wrote:
> Documentation for function_duration tracer.

> +The purpose of the function duration tracer is to help find the
> +longest-running, most time-consuming functions in the Linux kernel.
> +This is especially important for early initialization, to reduce
> +kernel boot time.
> +
> +Function duration tracing uses the ftrace ability to hook both the
> +entry and exit of a function, to record duration information for
> +kernel functions.  This is similar to the function_graph tracer, but
> +the function_duration tracer is specially written to support filtering
> +by duration and decreased tracer overhead while filtering.
> +
> +This extends the amount of time that a trace can cover, and reduces
> +interference with the timing of the traced activity.

BTW, have you taken a look at the function profiler? It also keeps track
of all durations without using the ring buffer. It just adds them up and
gives an average time.

-- Steve




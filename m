Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbZLJDow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbZLJDow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 22:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759503AbZLJDot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 22:44:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52685 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759499AbZLJDos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 22:44:48 -0500
X-Authority-Analysis: v=1.0 c=1 a=YKJKX32jWyIA:10 a=7U3hwN5JcxgA:10 a=Wi-Rh9meTOhXRApSrYIA:9 a=fbHHRe08erOBurPokUIqBZDTEAkA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/4] ftrace - expose tracing_thresh and global_trace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B202763.10604@am.sony.com>
References: <4B202763.10604@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 09 Dec 2009 22:44:54 -0500
Message-ID: <1260416694.2146.132.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 14:40 -0800, Tim Bird wrote:
> Make tracing_thresh and global_trace available for
> function_duration tracer.

I'm OK with globalizing tracing_thresh, but NAK on the global_trace. See
how function and function graph tracer handle this. It is still possible
that in the future the global_trace may not exist.

-- Steve



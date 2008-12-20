Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbYLTNC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbYLTNC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 08:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYLTNCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 08:02:24 -0500
Received: from ozlabs.org ([203.10.76.45]:37907 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbYLTNCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 08:02:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 5/8] cpumask: convert rest of files in kernel/
Date: Sat, 20 Dec 2008 23:32:04 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Richard Henderson <rth@twiddle.net>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com> <20081219160145.404769000@polaris-admin.engr.sgi.com>
In-Reply-To: <20081219160145.404769000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812202332.05331.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2008 02:31:49 Mike Travis wrote:
> Impact: Reduce stack usage, use new cpumask API.  ALPHA mod!

This need to be split, I think.  I was just lazy in leaving the conversion
as one big patch.

> Note that prof_cpu_mask will be difficult to convert to a cpumask_var_t
> since it needs to be ready from the first scheduler tick.

Actually, I think this one can be fixed quite easily.

OK, I've done this.  Compiles...
Rusty.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYJaNKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYJaNKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJaNKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:10:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:22385 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYJaNKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:10:17 -0400
Message-ID: <f488382f0810310610n20a13163pb0936a3104e64a5c@mail.gmail.com>
Date: Fri, 31 Oct 2008 06:10:13 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Dimitri Sivanich" <sivanich@sgi.com>
Subject: Re: [PATCH] small optimization to update_curr_rt
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081031130341.GA12018@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031130341.GA12018@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 6:03 AM, Dimitri Sivanich <sivanich@sgi.com> wrote:
> A very minor improvement, but might it be better to check sched_rt_runtime(rt_rq)
> before taking the rt_runtime_lock?

Is it possible that the attribute sched_rt_runtime is checking could
change by the time it acquires the lock? If not, should be fine, I
think.

- Steven

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZBDKlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZBDKlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZBDKlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:41:40 -0500
Received: from ozlabs.org ([203.10.76.45]:33912 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbZBDKlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:41:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Date: Wed, 4 Feb 2009 21:11:35 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200902041314.32277.rusty@rustcorp.com.au> <20090203190111.2ec31cef.akpm@linux-foundation.org>
In-Reply-To: <20090203190111.2ec31cef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042111.35543.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 13:31:11 Andrew Morton wrote:
> On Wed, 4 Feb 2009 13:14:31 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> > I think you're right though: smp_call_function_single (or neat wrappers)
> > where possible, work_on_cpu which can fail for the others, and we'll just
> > have to plumb in the error returns.
> 
> I bet a lot of those can use plain old schedule_work_on().

Which is where work_on_cpu started: a little wrapper around schedule_work_on.

We're going in circles, no?
Rusty.

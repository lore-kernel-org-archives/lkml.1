Return-Path: <linux-kernel-owner+w=401wt.eu-S1765330AbXLMVdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765330AbXLMVdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765223AbXLMVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:32:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469AbXLMVcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:32:23 -0500
Date: Thu, 13 Dec 2007 13:32:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: Next patches for the 2.6.25 queue
Message-Id: <20071213133202.11374f54.akpm@linux-foundation.org>
In-Reply-To: <20071213144642.GA7800@Krystal>
References: <20071213144642.GA7800@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 09:46:42 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Andrew,
> 
> I would like to post my next patches in a way that would make it as
> easy for you and the community to review them. Currently, the patches
> that have really settled down are :
> 
> * For 2.6.25
> 
> - Text Edit Lock
>   - Looks-good-to Ingo Molnar.
> - Immediate Values
>   - Redux version, asked by Rusty
> 
> * For 2.6.25 ?
> 
> Another patchset that is technically ok (however Rusty dislikes the
> complexity inherent to the algorithms required to be reentrant wrt NMI
> and MCE, although it's been reviewed by the community for months). I
> have also replyed to Ingo's concerns about effeciency of my approach
> compared to dtrace by providing numbers, but he has not replyed yet.
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg238317.html
> 
> - Markers use Immediate Values
> 
> * Maybe for 2.6.26 ...
> 
> Once we have this, and the instrumentation (submitted as RFC in the past
> weeks), in the kernel, the only architecture dependent element that will
> be left is the LTTng timestamping code.
> 
> And then, from that point, the following patchset is mostly
> self-contained and stops modifying code all over the kernel tree. It
> is the LTTng tracer.
> 
> Trying to improve my approach : I guess that submitting at most 15
> patches at a time (each 1-2 days), against the -mmotm tree, would be the
> way to do it ?
> 

Just for some context, I have...

- 1,400-odd open bugzilla reports

- 719 emails saved away in my emailed-bug-reports folder, all of which
  need to be gone through, asking originators to retest and
  re-report-if-unfixed.

- A big ugly email titled "2.6.24-rc5-git1: Reported regressions from
  2.6.23" in my inbox.

All of which makes it a bit inappropriate to be thinking about
intrusive-looking new features.

Ho hum.  Just send me the whole lot against rc5-mm1 and I'll stick it in
there and we'll see what breaks.


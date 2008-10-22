Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbYJVNri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbYJVNri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYJVNr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:47:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:54388 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYJVNr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:47:28 -0400
Date: Wed, 22 Oct 2008 06:47:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Gregory Haskins <gregory.haskins.ml@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: deep power-saving states
Message-ID: <20081022064738.05818670@infradead.org>
In-Reply-To: <48FF2DDC.5010600@gmail.com>
References: <48FF2DDC.5010600@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 09:42:52 -0400
Gregory Haskins <gregory.haskins.ml@gmail.com> wrote:

> What I was thinking is that a simple mechanism to quantify the
> power-state penalty would be to add those states as priority levels in
> the cpupri namespace.  E.g. We could substitute IDLE-RUNNING for IDLE,
> and add IDLE-PS1, IDLE-PS2, .. IDLE-PSn, OTHER, RT1, .. RT99.  This
> means the scheduler would favor waking an IDLE-RUNNING core over an
> IDLE-PS1-PSn, etc.  The question in my mind is: can the power-states
> be determined in a static fashion such that we know what value to
> quantify the idle state before we enter it?  Or is it more dynamic
> (e.g. the longer it is in an MWAIT, the deeper the sleep gets).

it's a little dynamic, but just assuming the worst will be a very good
approximation of reality. And we know what we're getting into in that
sense.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

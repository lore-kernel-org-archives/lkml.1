Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYJ3OdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYJ3OdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbYJ3Oc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:32:57 -0400
Received: from lazybastard.de ([212.112.238.170]:59276 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbYJ3Oc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:32:56 -0400
Date: Thu, 30 Oct 2008 15:32:39 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Daniel Walker <dwalker@mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2 v3][RFC] trace: profile likely and unlikely annotations
Message-ID: <20081030143238.GB7157@logfs.org>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu> <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com> <20081028143720.GD8869@mit.edu> <20081028074816.04193e04@infradead.org> <alpine.DEB.1.10.0810281050440.29482@gandalf.stny.rr.com> <alpine.DEB.1.10.0810291233580.13214@gandalf.stny.rr.com> <alpine.DEB.1.10.0810291833540.6145@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.1.10.0810291833540.6145@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 October 2008 18:39:55 -0400, Steven Rostedt wrote:
>
>    69768    61064  87 __switch_to                    process_64.c         624
>    15557   115251 100 __switch_to                    process_64.c         594
>    15555   115227 100 __switch_to                    process_64.c         590

I may be out of school for a while, but that math sure looks odd.

> +	if (p->correct) {
> +		percent = p->incorrect * 100;
> +		percent /= p->correct;
                percent /= p->correct + p->incorect;
> +		/* No need to see huge numbers */
> +		if (percent > 100)
> +			percent = 100;
> +	} else
> +		percent = p->incorrect ? 100 : 0;

Jörn

-- 
To my face you have the audacity to advise me to become a thief - the worst
kind of thief that is conceivable, a thief of spiritual things, a thief of
ideas! It is insufferable, intolerable!
-- M. Binet in Scarabouche

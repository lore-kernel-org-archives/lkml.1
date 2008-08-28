Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbYH1Ogx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbYH1Ogx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYH1Ogp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:36:45 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:36587 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752833AbYH1Ogp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:36:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=APHZc4gJwtAKTYjyt/W9th4iESrFI98tWa3e0MV/ygHUhWovF0pVmxdFXjKt9MqpCyj4whB9QZ5R5OQyxkwlNd4xrSvmVF3IewmBd7kMiQNjjvxgOZkz1WkyuKIiWkpmJvZZXY9bpydZXt1sNF4v1YlEbSBNAhmtCM1LsnMJDOo=  ;
X-YMail-OSG: Z34225UVM1mWJ33rcTSgKbZkjDspTsl.DuHLR1bPTe1ujYWffynvdk89Xeny9kgv.ENa5w8aenhEtuEIw2WglgNehcjJW3t4VYkKh4xPqRFXTA6pnxYnUvc1JN0olLicwE32Luzhq8DkYxDrI01WYK0.
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Fri, 29 Aug 2008 00:36:35 +1000
User-Agent: KMail/1.9.5
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080819103301.787700742@chello.nl> <20080828141513.GC31444@goodmis.org> <20080828143042.GA12644@elte.hu>
In-Reply-To: <20080828143042.GA12644@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808290036.35817.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008 00:30, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> > For this, if this time limit does kick in, we should at the very least
> > print something out to let the user know this happened. After all,
> > this is more of a safety net anyway, and if we are hitting the limit,
> > the user should be notified. Perhaps even tell the user that if this
> > behaviour is expected, to up the sysctl <var> by more.
>
> yeah, agreed, this is a reasonable suggestion. Peter, do you agree?

Seems reasonable. But I still think it should be disabled by default
(it might not get caught in testing for example).

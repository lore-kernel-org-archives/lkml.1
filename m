Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYH0KId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYH0KId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYH0KIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:08:25 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:46852 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753344AbYH0KIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:08:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Fu+ww/+ESg3Ni/kyzq1HwTowiQ01BfPRm6RQ7wmIiUC1zEpYku40prCV+lOApU+9qYpPZH02Sq4GaSV+a5edxyhXzvorsC+vsh9d9peyY+qHLHMZQ4Rs7CyjJ860fp3fH2Zm+819uzrF+bk6ZZPzhir92nwQ1rjPmeRKtVm/Zxg=  ;
X-YMail-OSG: vUlxRbQVM1nr5QAbrAt4ybJan.5K8gB1G57B0DhmWnbXu7L94Va.PwSu6mlUzJwDjuW9b15skXrFAySlvHyGc.YHsd9W4eZflH3SxVfN58Zm5xNnAi42M1zrOvFZEUz9MkDH9bIS8uqkW8rL0I6DhNah
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Wed, 27 Aug 2008 20:08:15 +1000
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de> <874p57s873.fsf@basil.nowhere.org>
In-Reply-To: <874p57s873.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808272008.16106.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008 08:49, Andi Kleen wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> > Well, we might have a public opinion poll, whether a system is
> > declared frozen after 1, 10 or 100 seconds. Even a one second
> > unresponsivness shows up on the kernel bugzilla and you request that
> > unlimited unresponsivness w/o a chance to debug it is the sane
> > default.
>
> That assumes single CPU. With multiple CPUs and not
> all hogged the system should be still responsive?

Right.

But also it assumes desktop/general purpose server thing.

There may not even be any user interface to be unresponsive. Or it
may be something implemented with a userspace driven scheduling
system. Or an event loop in a single process.

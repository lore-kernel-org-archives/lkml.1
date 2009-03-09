Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZCIPn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZCIPn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZCIPnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:43:17 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:56603 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404AbZCIPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:43:17 -0400
From: Frans Pop <elendil@planet.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG,2.6.29-rc7,s390] System goes into endless loop during boot or logon
Date: Mon, 9 Mar 2009 16:43:11 +0100
User-Agent: KMail/1.9.9
Cc: linux-s390@vger.kernel.org,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903080835.14032.elendil@planet.nl> <200903090253.34173.elendil@planet.nl> <1236587118.8389.20.camel@laptop>
In-Reply-To: <1236587118.8389.20.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903091643.13803.elendil@planet.nl>
X-OriginalArrivalTime: 09 Mar 2009 15:43:14.0424 (UTC) FILETIME=[C23C4780:01C9A0CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 March 2009, Peter Zijlstra wrote:
> On Mon, 2009-03-09 at 02:53 +0100, Frans Pop wrote:
> > Follow-up to an issue reported on the linux-s390 list, seen in the
> > Hercules S/390 emulator.
> >
> > On Sunday 08 March 2009, Frans Pop wrote:
> > > Well, not quite. It does boot successfully and I do get a login
> > > prompt. I can also login on the console or connect with SSH, but in
> > > both cases the system again gets into some loop before I actually
> > > get a shell prompt.
> >
> > During the bisection series the system would sometimes enter the loop
> > during the boot procedure, before I tried to logon. After it enters
> > the loop one processor just goes racing at 100%.
>
> Where? Do you have NMI watchdog output, or even sysrq-t?

Hmmm. Your commit log message for ca109491f612aab5c8152207631c0444f63da97f 
does explicitly mention the risk of an infinite loop, as does a comment 
in hrtimer_enqueue_reprogram().

Any chance the cause is there? Any way to test for that?

Cheers,
FJP

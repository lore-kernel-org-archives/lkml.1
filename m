Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYIENxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYIENxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYIENwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:52:53 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:56623 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYIENww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:52:52 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: frame unwinder patches
Date: Fri, 5 Sep 2008 15:52:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
References: <g9p3du$n95$1@ger.gmane.org> <200809051119.21699.bs@q-leap.de> <20080905063317.5e3a2b2c@infradead.org>
In-Reply-To: <20080905063317.5e3a2b2c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809051552.47929.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2008 15:33:17 Arjan van de Ven wrote:
> On Fri, 5 Sep 2008 11:19:21 +0200
>
> Bernd Schubert <bs@q-leap.de> wrote:
> > > not printing the ? would be trivial (for some backtraces we do
> > > that), but so far hasn't been seen as desirable because you lose
> > > information in those hard-to-debug cases when you need anything you
> > > can get from the backtrace.
> >
> > I see your point, but in most cases it is rather annoying.
>
> ... if you see backtraces regularly there's something wrong ;-)

It always depends on what you are doing. Presently I'm fixing the 
reset-handler of the mpt fusion driver and since I'm not 
$hardcore_kernel_hacker_with_super_scsi_knowlegde, but only know C and a 
little bit about the kernel API I insert dump_stack() and printks all over 
the place into the code to understand what is going on.

Well, this reset part is mostly done, now this problem: 
http://marc.info/?l=linux-scsi&m=118039573814323&w=2

So yes, there is something wrong ;) Unfortunately so far nobody cared about 
these bugs we are hitting regularily.

>
> (and if you really care it's 1 line of code to turn it off)

It is not only this, I think the dwarf2 stack unwinder patches provide by far 
better traces than the in-kernel unwinder. At least ever since I applied 
these patches to our kernels, I was able to read the stack dumps...


Cheers,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH

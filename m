Return-Path: <linux-kernel-owner+w=401wt.eu-S932243AbZHYVJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbZHYVJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932139AbZHYVJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:09:52 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:12489 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbZHYVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:09:51 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.479
Message-ID: <4A945317.5040501@tudelft.nl>
Date: Tue, 25 Aug 2009 23:09:43 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090815 Mandriva/2.0.0.22-4mdv2010.0 (2010.0) Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, raz ben yehuda <raziebe@gmail.com>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
References: <1250983671.5688.21.camel@raz>	 <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>	 <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>	 <1251021133.14003.172.camel@marge.simson.net>	 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>	 <1251222993.7023.53.camel@marge.simson.net>	 <alpine.DEB.1.10.0908251402300.17963@gentwo.org> <1251227322.7538.1172.camel@twins>
In-Reply-To: <1251227322.7538.1172.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 25-08-09 21:08, Peter Zijlstra schreef:
> On Tue, 2009-08-25 at 14:03 -0400, Christoph Lameter wrote:
>> On Tue, 25 Aug 2009, Mike Galbraith wrote:
>>
>>> I asked the questions I did out of pure curiosity, and that curiosity
>>> has been satisfied.  It's not that I find it useless or whatnot (or that
>>> my opinion matters to anyone but me;).  I personally find the concept of
>>> injecting an RTOS into a general purpose OS with no isolation to be
>>> alien.  Intriguing, but very very alien.
>> Well lets work on the isolation piece then. We could run a regular process
>> on the RT cpu and switch back when OS services are needed?
> 
> Christoph, stop being silly, this offline scheduler thing won't happen,
> full stop.
> 
> Its not a maintainable solution, it doesn't integrate with existing
> kernel infrastructure, and its plain ugly.
> 
> If you want something work within Linux, don't build kernels in kernels
> or other such ugly hacks.
Hello,

For the one interested in such approach, you can have a look at an now
unmaintained project that we developed, ARTiS:
http://www2.lifl.fr/west/artis/

It allows several RT tasks to share a "RT" cpu, and if a task tries to
"cheat" by calling a kernel function which disables the preemption or
the interrupts, it is temporally migrated to another CPU. This is a
working approach, with some good low latency results which can be seen
in the papers on the website.

See you,
Eric

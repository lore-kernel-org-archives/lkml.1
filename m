Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbXFWO3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbXFWO3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 10:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbXFWO3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 10:29:48 -0400
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:49049 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902AbXFWO3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 10:29:47 -0400
Date: Sat, 23 Jun 2007 16:28:37 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Alberto Gonzalez <info@gnebu.es>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about fair schedulers
Message-ID: <20070623162837.47f31bf8@localhost>
In-Reply-To: <200706231556.36430.info@gnebu.es>
References: <200706230007.15622.info@gnebu.es>
	<200706231001.02497.info@gnebu.es>
	<20070623152653.05ebac64@localhost>
	<200706231556.36430.info@gnebu.es>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 15:56:36 +0200
Alberto Gonzalez <info@gnebu.es> wrote:

> > And yes, programs/distributions should set good defaults for you... and
> > if they don't, just complain to them  :)  
> 
> I'm sure they'll do once a fair scheduler goes into mainline :)

Some already does... for example the current version of:
	http://www.exit1.org/dvdrip/

it sets transcode nice to "+19" by default  :)

> 
> I guess what I was missing from the beginning is that "fair" means that the 
> scheduler will be fair among tasks that have the same priority, but if a task 
> has a higher priority, it _will_ get more CPU. So we'll just have to mark 
> applications like video players, audio players or games with a high priority, 
> others like encoders or compilers with low priority, and leave the rest 
> (browsers, word processors, email readers, etc...) as normal priority. This 
> way a fair scheduler would be able to give each task right amount of CPU.

Yes. I think that the more important thing is to nice background tasks
(like encoders etc..), then games / video players can run without
problems even without renicing (usually normal programs don't eat much
CPU).

-- 
	Paolo Ornati
	Linux 2.6.22-rc5-g0864a4e2 on x86_64

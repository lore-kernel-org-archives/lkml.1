Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZEDSAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZEDSAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbZEDR7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:59:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:52125 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751282AbZEDR7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:59:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19WBhs8L8RWXkWWrsorSvbaLSrd9DorPUUB6kzQua
	3QqIOIsbhZj+Kd
Subject: Re: CFS not suitable for desktop computers
From: Mike Galbraith <efault@gmx.de>
To: Nico =?ISO-8859-1?Q?Sch=FCmann?= <spam@nico22.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <49FF06D0.80109@nico22.de>
References: <49FDEFD1.8020608@nico22.de>
	 <1241424835.26855.102.camel@marge.simson.net>  <49FF06D0.80109@nico22.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 04 May 2009 19:59:43 +0200
Message-Id: <1241459983.5462.70.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 17:16 +0200, Nico Schümann wrote:
> Thank you Ray Lee and Mike Galbraith for your responses, I ran the 
> script and attached its gathered information.
> 
> Mike Galbraith wrote:
> > How hard is hard?  Can you describe the loads you're having trouble
> > with, and the hardware you're running them on?
> >
> >   
> I could reproduce "hard" load by just compiling the linux kernel, make 
> -j3 while reading mails with Thunderbird, which is not that hard 
> foreground load. Thunderbird starts reacting really slowly while compiling.
> 
> My system has a 1,3 GHz AMD Athlon CPU (32 bits) and 1 GB of RAM. Now 
> you will say: That is not very much. Of course it is not, but with the 
> old scheduler, the system felt way faster, so it seemed to be enough for 
> compiling and reading mails.

Hm.  The load isn't extreme, but it appears to me that between X and
Thunderbird, CPU demand is high enough that you WILL feel the slowdown
when you toss in three competing CPU hogs plus other system activity all
on one core.

> I hope you can find useful information in the attached log, I enabled 
> SCHED_DEBUG and SCHEDSTATS, if you need any more information, just ask 
> me, I will try to answer.

I'll look closer tomorrow (ill).  For now, how much CPU does
X/Thunderbird consume without the kbuild?

(I know this isn't what you want to hear, but SCHED_IDLE is a major case
of happiness for heavy lifting background loads, especially so on UP.)

	-Mike


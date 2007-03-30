Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXC3Pua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXC3Pua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 11:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXC3Pua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 11:50:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40192 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbXC3Pu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 11:50:29 -0400
Subject: Re: exposing FSB clock speed in /sys
From: Arjan van de Ven <arjan@infradead.org>
To: eranian@hpl.hp.com
Cc: linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com
In-Reply-To: <20070330153937.GC16059@frankl.hpl.hp.com>
References: <20070330153937.GC16059@frankl.hpl.hp.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 30 Mar 2007 08:49:52 -0700
Message-Id: <1175269792.3360.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 07:39 -0800, Stephane Eranian wrote:
> Hello,
> 
> It seems that the kernel does not expose the Front-Side Bus (FSN) Clock
> speed to user applications

and that is a good thing ;)



> Knowledge the the FSB speed is very useful to monitoring tools. It is used
> to compute certain bus-related metrics.

perhaps. 
> 
> Looking at the code, it seems that there is no standard way of extracting
> the FSB speed. For each processor model, you have different MSRs. I would
> think that the routines in the cpufreq code could be moved out and used
> as the basis to expose the information somewhere in /sys.

... yet not all CPU's *have* an FSB. Notably AMD ones do not, and I'm
sure you've read on a lot of online tech magazines that other vendors
may also not have one in the future  :-)

Exposing a concept that we KNOW does not make sense via a kernel
interface (which means we need to keep it around forever) is in my
opinion quite a bad mistake to make.... Please lets not do this.




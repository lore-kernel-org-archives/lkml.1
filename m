Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbXIJRYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbXIJRYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXIJRYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:24:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871AbXIJRYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:24:07 -0400
Date: Mon, 10 Sep 2007 10:22:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: vatsa@linux.vnet.ibm.com
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       ckrm-tech@lists.sourceforge.net, dhaval@linux.vnet.ibm.com
Subject: Re: [PATCH] Hookup group-scheduler with task container
 infrastructure
Message-Id: <20070910102259.dc45a481.akpm@linux-foundation.org>
In-Reply-To: <20070910172334.GB19100@linux.vnet.ibm.com>
References: <20070910171049.GA16048@linux.vnet.ibm.com>
	<Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
	<20070910172334.GB19100@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 22:53:34 +0530 Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Mon, Sep 10, 2007 at 07:05:00PM +0200, Jan Engelhardt wrote:
> > On Sep 10 2007 22:40, Srivatsa Vaddagiri wrote:
> > >+#ifdef CONFIG_FAIR_GROUP_SCHED
> > >+SUBSYS(cpuctlr)
> > >+#endif
> > 
> > cpuctl, cpuctrl, cpu_controller?
> 
> *shrug* .. I used "cpuctlr" to mean "CPU Controller". Any other short names
> would do. From your list, cpuctl or cpuctrl both qualifies IMO!
> 
> Unless folks have strong objection to it, I prefer "cptctlr", the way it is.
> 

objection ;)  "cpuctlr" isn't memorable.  Kernel code is write-rarely,
read-often.  "cpu_controller", please.  The extra typing is worth it ;)

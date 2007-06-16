Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbXFPGro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbXFPGro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 02:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXFPGri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 02:47:38 -0400
Received: from www.osadl.org ([213.239.205.134]:55026 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752202AbXFPGrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 02:47:37 -0400
Subject: Re: Jinxed VAIO wreckage - current state of affairs
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <20070615233138.78a79b00.akpm@linux-foundation.org>
References: <1181418873.4404.402.camel@chaos>
	 <200706092259.50694.rjw@sisk.pl>
	 <20070609200827.635fec79.akpm@linux-foundation.org>
	 <1181909157.8176.342.camel@chaos>
	 <20070615082324.203610ec.randy.dunlap@oracle.com>
	 <1181921466.8176.356.camel@chaos>
	 <20070615233138.78a79b00.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 16 Jun 2007 08:47:33 +0200
Message-Id: <1181976453.8176.362.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 23:31 -0700, Andrew Morton wrote:
> > 
> > http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt10.patch
> > 
> 
> That suspends and resumes OK.
> 
> What was the bug?

A stupid state check, which prevented the PIT to be setup again. So the
box got stuck waiting for a timer to expire.

Still I can not explain, why this resulted in this strange "disappear in
the return instruction" behavior.

	tglx



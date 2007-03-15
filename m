Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbXCOTxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbXCOTxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbXCOTxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:53:21 -0400
Received: from gw.goop.org ([64.81.55.164]:51371 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933569AbXCOTxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:53:20 -0400
Message-ID: <45F9A42D.7090205@goop.org>
Date: Thu, 15 Mar 2007 12:53:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: dwalker@mvista.com, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au.ibm.com,
       schwidefsky@de.ibm.com, Rik van Riel <riel@redhat.com>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org> <45F85A62.8050001@vmware.com> <45F85BBB.70707@goop.org> <45F85F43.9030803@vmware.com> <45F866AF.9060609@goop.org> <45F999D4.6080602@vmware.com>
In-Reply-To: <45F999D4.6080602@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> Available time is defined to be (real_time - stolen_time).  i.e. time
> in which the vcpu is either running or not ready to run [because it is
> halted, and nothing is pending]).

Hm, the Xen definition of stolen time is "time VCPU spent in runnable
(vs running) or offline state".  If the VCPU was blocked anyway, then
its never considered to be stolen.  Offline means the VCPU was paused by
the administrator, or during suspend/resume.

    J

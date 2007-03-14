Return-Path: <linux-kernel-owner+w=401wt.eu-S1422653AbXCNU7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422653AbXCNU7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422660AbXCNU7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:59:54 -0400
Received: from gw.goop.org ([64.81.55.164]:50146 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422653AbXCNU7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:59:53 -0400
Message-ID: <45F86247.40109@goop.org>
Date: Wed, 14 Mar 2007 13:59:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dan Hecht <dhecht@vmware.com>, dwalker@mvista.com,
       cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       paulus@au.ibm.com, schwidefsky@de.ibm.com,
       Rik van Riel <riel@redhat.com>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org> <1173816769.22180.14.camel@localhost> <45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org> <20070314203826.GA15394@elte.hu>
In-Reply-To: <20070314203826.GA15394@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> touching the 'timer tick' is the wrong approach. 'stolen time' only 
> matters to the /scheduler tick/. So extend the hypervisor interface to 
> allow the injection of 'virtual' scheduler tick events: via the use of a 
> special clockevents device - do not change clockevents itself.

I didn't.  I was using sloppy terminology: I hang the stolen time
accounting off the Xen timer interrupt routine, just so that it gets run
every now and again.

I suppose I could explicitly hook stolen time accounting into the
scheduler, but its not obvious to me that it's necessary.

    J

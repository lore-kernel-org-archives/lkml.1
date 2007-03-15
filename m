Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbXCOUXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbXCOUXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933798AbXCOUXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:23:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795AbXCOUXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:23:06 -0400
Message-ID: <45F9A93A.2030400@redhat.com>
Date: Thu, 15 Mar 2007 16:14:50 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, dwalker@mvista.com,
       cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au.ibm.com,
       schwidefsky@de.ibm.com, Zachary Amsden <zach@vmware.com>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org> <45F85A62.8050001@vmware.com> <45F85BBB.70707@goop.org> <45F85F43.9030803@vmware.com> <45F866AF.9060609@goop.org> <45F999D4.6080602@vmware.com> <45F9A42D.7090205@goop.org> <45F9A788.1010008@vmware.com>
In-Reply-To: <45F9A788.1010008@vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:

> Yes, the part in the "i.e." above is describing available time.  So, it 
> is essentially is the same definition of stolen time VMI uses:

> stolen time     == ready to run but not running
> available time  == running or not ready to run

S390 too.  We were quite careful to make sure that steal time
means the same on the different platforms when the code was
introduced.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.

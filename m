Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbZHGVcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbZHGVcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZHGVcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:32:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:32781 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753529AbZHGVcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:32:13 -0400
X-Authenticated: #2360897
X-Provags-ID: V01U2FsdGVkX1+aZp8C6/maqt47FIuuQYqkeH389iuBRMGo81U/Hc
	0UgPu1ORnrgzuY
Message-ID: <4A7C9D48.3030405@gmx.de>
Date: Fri, 07 Aug 2009 23:31:52 +0200
From: Bernhard Walle <bernhard.walle@gmx.de>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Amerigo Wang <amwang@redhat.com>, Neil Horman <nhorman@redhat.com>,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andi Kleen <andi@firstfloor.org>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>	<m1eirqtmey.fsf@fess.ebiederm.org>	<20090805140408.GJ7259@hmsreliant.think-freely.org>	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>	<m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com>	<m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com>	<m1bpmtqxjh.fsf@fess.ebiederm.org> <4A7A7A0F.6070906@redhat.com>	<m1iqh1nxv3.fsf@fess.ebiederm.org> <4A7A9E54.60705@redhat.com> <m1iqgze740.fsf@fess.ebiederm.org>
In-Reply-To: <m1iqgze740.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman schrieb:
> 
> With the current set of crashkernel= options we are asking the
> distribution installer to perform magic.  Moving as much of this logic
> into a normal init script for better maintenance is desirable.

Not (necessarily) the installer but the program that configures kdump.
system-config-kdump on Red Hat, YaST on SUSE.

> Bernhard does that sound useful to you?

I don't see any problems. I don't know how much effort is it to free
already reserved crashkernel memory, but I guess it's not really
complicated. Maybe that "1/32" should be specified on the command line like


	crashkernel=>>5

(for 1/32*system_memory == system_memory>>5), OTOH I have no real strong
opinion.


Regards,
Bernhard

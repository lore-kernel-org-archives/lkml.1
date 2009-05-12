Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbZELHw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbZELHw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZELHws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:52:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65186 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbZELHwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:52:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
Date: Tue, 12 May 2009 09:52:12 +0200
User-Agent: KMail/1.9.9
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20090508165219.469818319@chello.nl> <1242109650.11251.313.camel@twins> <1242112226.11251.315.camel@twins>
In-Reply-To: <1242112226.11251.315.camel@twins>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905120952.12847.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1823ZjjQsyaxfGHj4oupTnZ/ZWb0HsgXPgcfA7
 LB6HaNVGf7DU9XEo3EvoNEfLJwy4LgNt7RygPtnJseMQfgSoYM
 CC6qlugKjUNlXaSACI+9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Peter Zijlstra wrote:
> Ah, so _IO() gets an unsigned long 3rd argument.
> _IOW() treats the 3rd arg as a (type __user *) and copies the bits over
> _IOR() copies the bits back out to userspace
> _IORW() does both
> 
> In which case the below should fix things up, no?
> 

Yes, this looks good now.

Thanks,

	Arnd <><

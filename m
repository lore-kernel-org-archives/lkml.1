Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXCAR2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXCAR2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965457AbXCAR2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:28:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57976 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965456AbXCAR2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:28:42 -0500
Date: Thu, 1 Mar 2007 09:14:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-dvb@linuxtv.org, domi.dumont@free.fr,
       Jiri Slaby <jirislaby@gmail.com>, bunk@stusta.de,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>,
       venkatesh.pallipadi@intel.com
Subject: Re: 2.6.21-rc1-git2 is incompilable
Message-Id: <20070301091452.7f1bd700.randy.dunlap@oracle.com>
In-Reply-To: <20070301143407.29950@gmx.net>
References: <20070301143407.29950@gmx.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 15:34:07 +0100 Uwe Bugla wrote:

> Hi folks,
> trying to compile kernel 2.6.21-rc1-git2 is impossible. The broken module where the compiler gives up is /arch/i386/kernel/io_apic.c.
> 
> Regards
> 
> Uwe
> 
> P. S.: Wouldn't it be a good idea to test at least error-free compilation before stuff like this is being published?

1) 2.6.*-gitN kernels are automated snapshots of Linus's git kernel tree.
There is no coordination between Linus adding changesets to his kernel
tree and some script reading changes out of it.  (I could read your
note as saying that there should be some coordination, I suppose.)

2) Linus doesn't build i386 non-SMP kernels AFAIK.

3) The small bug has been discussed & fixed (several times).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

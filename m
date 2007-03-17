Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbXCRAsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbXCRAsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbXCRAsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:48:07 -0400
Received: from ozlabs.org ([203.10.76.45]:32952 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbXCRAsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:48:06 -0400
Subject: Re: [PATCH RESEND 2/2] Fix some kallsyms_lookup() vs rmmod races
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paulo Marques <pmarques@grupopie.com>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       devel@openvz.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070316124949.3227a945.akpm@linux-foundation.org>
References: <20070316114458.GB6817@localhost.sw.ru>
	 <20070316115154.GC30195@elte.hu> <45FAC2CA.80009@grupopie.com>
	 <20070316161853.GD9413@elte.hu> <45FAD0F7.5090506@grupopie.com>
	 <20070316101514.8a8ffbc7.akpm@linux-foundation.org>
	 <45FAFDB1.3030902@grupopie.com>
	 <20070316124949.3227a945.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 21:36:33 +1100
Message-Id: <1174127793.8897.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 12:49 -0800, Andrew Morton wrote:
> > Ok, I've just done a few tests with the attached patch. It basically 
> > creates a freeze_machine_run function that is equivalent in interface to 
> > stop_machine_run, but uses freeze_processes / thaw_processes to stop the 
> > machine.

I've never been convinced that the freezer was a good idea.
stop_machine is a damn big hammer, but it works.

Rusty.



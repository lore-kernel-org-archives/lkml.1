Return-Path: <linux-kernel-owner+w=401wt.eu-S1754368AbXJAQNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbXJAQNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXJAQMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:12:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbXJAQMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:12:51 -0400
Date: Mon, 1 Oct 2007 12:12:21 -0400
From: Dave Jones <davej@redhat.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH] Add sysfs control to modify a user's cpu share
Message-ID: <20071001161221.GB23969@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@elte.hu>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Mike Galbraith <efault@gmx.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Sudhir Kumar <skumar@linux.vnet.ibm.com>
References: <1190723327.7112.5.camel@Homer.simpson.net> <1190724893.13716.8.camel@Homer.simpson.net> <20070925131717.GM26289@linux.vnet.ibm.com> <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001140454.GA19439@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 07:34:54PM +0530, Dhaval Giani wrote:
 > Hi Ingo,
 > 
 > Adds tunables in sysfs to modify a user's cpu share.
 > 
 > A directory is created in sysfs for each new user in the system.
 > 
 > 	/sys/kernel/uids/<uid>/cpu_share
 > 
 > Reading this file returns the cpu shares granted for the user.
 > Writing into this file modifies the cpu share for the user. Only an 
 > administrator is allowed to modify a user's cpu share.
 > 
 > Ex: 
 > 	# cd /sys/kernel/uids/
 > 	# cat 512/cpu_share
 > 	1024
 > 	# echo 2048 > 512/cpu_share
 > 	# cat 512/cpu_share
 > 	2048
 > 	#

Can we start adding stuff to Documentation/ for new files created
in sysfs ?  There's so much undocumented stuff in there now that
it's unfunny.

A great start would be 'wtf is a cpu_share and why would I want to
change it' ?

	Dave

-- 
http://www.codemonkey.org.uk

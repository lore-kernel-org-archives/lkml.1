Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbXJAQ0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbXJAQ0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbXJAQ0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:26:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47958 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbXJAQ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:26:29 -0400
Date: Mon, 1 Oct 2007 22:07:24 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH] Add sysfs control to modify a user's cpu share
Message-ID: <20071001163721.GF5724@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1190724893.13716.8.camel@Homer.simpson.net> <20070925131717.GM26289@linux.vnet.ibm.com> <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001161221.GB23969@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001161221.GB23969@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 12:12:21PM -0400, Dave Jones wrote:
> Can we start adding stuff to Documentation/ for new files created
> in sysfs ?  There's so much undocumented stuff in there now that
> it's unfunny.

Hi Dave,
	We will in the next version of the patch. At this point, the patch was 
sent out to get an idea of whether sysfs is the right place for this interface 
or not.

> A great start would be 'wtf is a cpu_share and why would I want to
> change it' ?

Quick answer before we release the next version : This has to do with
the CONFIG_FAIR_USER_SCHED feature which allows dividing CPU bandwidth
equally between all users of a system. Before this patch, CPU bandwidth was 
divided equally among all non-root users. After this patch, it will
be possible to control CPU bandwidth allocation to each user separately.

For ex: by setting user "vatsa"'s cpu_share to be twice that of user
"guest", it would be possible for user "vatsa" to get 2x CPU bandwidth that of 
user "guest"


--
Regards,
vatsa

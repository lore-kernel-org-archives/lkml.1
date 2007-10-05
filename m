Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbXJEGub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbXJEGub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 02:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbXJEGuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 02:50:24 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37183 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbXJEGuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 02:50:23 -0400
Date: Fri, 5 Oct 2007 12:31:17 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH -v2] Add sysfs control to modify a user's cpu share
Message-ID: <20071005070117.GB30528@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu> <20071003171029.GA5423@linux.vnet.ibm.com> <20071004075750.GD9176@elte.hu> <20071004085451.GA8108@osiris.boeblingen.de.ibm.com> <5596.1191533537@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5596.1191533537@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 05:32:17PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > Shouldn't that be done via uevents? E.g. UID x gets added to the sysfs tree,
> > generates a uevent and a script then figures out the cpu_share and sets it.
> 
> That would tend to be a tad racy - a site may want to set limits in the
> hypothetical /sys/kernel/uids/NNN before the program has a chance to fork-bomb
> or otherwise make it difficult to set a limitfrom within another userspace

Note that there is a default limit enforced on every new user (1024
value for the user's cpu share). This limit should contain any fork-bomb that
the user may launch immediately.

> process.  It's similar to why you want a process to be launched with all its
> ulimit's set, rather than set them after the fork/exec happens...





-- 
Regards,
vatsa

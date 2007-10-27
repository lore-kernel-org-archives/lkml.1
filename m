Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbXJ0Ffy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbXJ0Ffy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 01:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXJ0Ffq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 01:35:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60956 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXJ0Ffp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 01:35:45 -0400
Date: Fri, 26 Oct 2007 22:31:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Salyzyn, Mark" <mark_salyzyn@adaptec.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 7/9] irq-remove: scsi driver trivial
Message-ID: <20071026223137.5e311481@laptopd505.fenrus.org>
In-Reply-To: <4722885B.7050307@garzik.org>
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075808.GH6407@havoc.gtf.org>
	<AE4F746F2AECFC4DA4AADD66A1DFEF01F3D54D@otce2k301.adaptec.com>
	<20071026143525.b9218ed7.akpm@linux-foundation.org>
	<4722608E.3000405@garzik.org>
	<20071026165035.33383e36@laptopd505.fenrus.org>
	<47228278.8070505@garzik.org>
	<20071026171606.4e242f49@laptopd505.fenrus.org>
	<4722885B.7050307@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 20:37:47 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Arjan van de Ven wrote:
> > the other serious question is.. how is IRQ_HANDLER_V3 different
> > from a #ifdef VERSION >= 2.6.24 .....
> > it's not really ;)
> 
> Note my mention of backport -- kernel version isn't relevant when the 
> various enterprise distros have random featuresets under random
> kernel versions.
> 

yeah and THEY can put the defines in (RH used to do this fwiw as a
generic "this is a RH kernel" define)....

but afaik no distro vendor backports such an api change nowadays... and
hasn't in 2.6 ever


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

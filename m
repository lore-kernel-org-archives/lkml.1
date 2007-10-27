Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbXJ0OVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbXJ0OVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXJ0OVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:21:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46253 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbXJ0OVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:21:33 -0400
Date: Sat, 27 Oct 2007 07:17:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       "Salyzyn, Mark" <mark_salyzyn@adaptec.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 7/9] irq-remove: scsi driver trivial
Message-ID: <20071027071706.0ce9cb9f@laptopd505.fenrus.org>
In-Reply-To: <m1lk9proe0.fsf@ebiederm.dsl.xmission.com>
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075808.GH6407@havoc.gtf.org>
	<AE4F746F2AECFC4DA4AADD66A1DFEF01F3D54D@otce2k301.adaptec.com>
	<20071026143525.b9218ed7.akpm@linux-foundation.org>
	<4722608E.3000405@garzik.org>
	<20071026165035.33383e36@laptopd505.fenrus.org>
	<47228278.8070505@garzik.org>
	<20071026171606.4e242f49@laptopd505.fenrus.org>
	<4722885B.7050307@garzik.org>
	<20071026223137.5e311481@laptopd505.fenrus.org>
	<4722E360.7000305@garzik.org>
	<m1lk9proe0.fsf@ebiederm.dsl.xmission.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007 01:46:15 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> >>>
> >>
> >> yeah and THEY can put the defines in (RH used to do this fwiw as a
> >> generic "this is a RH kernel" define)....
> >>
> >> but afaik no distro vendor backports such an api change
> >> nowadays... and hasn't in 2.6 ever
> >
> > People backport drivers all the time that must support a wide range
> > of kernels.
> 
> I thought the argument was not that drivers are back ported but that
> internal kernel APIs changes aren't backported. 

exactly
> So that testing
> the kernel version actually has a chance as a reasonable test for
> features.

or at least for this level of API change

For this specific change, I don't see ANY distro just backporting
this ... so a version test is just fine for this change imo.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

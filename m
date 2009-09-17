Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbZIQEoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbZIQEoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 00:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZIQEoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 00:44:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbZIQEn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 00:43:59 -0400
Date: Thu, 17 Sep 2009 00:43:58 -0400 (EDT)
From: Miroslav Rezanina <mrezanin@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Message-ID: <1534444399.205511253162638763.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1772017457.205391253162074470.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH][v2.6.29][XEN] Return unused memory to
 hypervisor
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com> wrote:

> From: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
> To: "Miroslav Rezanina" <mrezanin@redhat.com>
> Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
> Sent: Wednesday, September 16, 2009 3:24:56 PM GMT +01:00 Amsterdam / Berlin / Bern / Rome / Stockholm / Vienna
> Subject: Re: [Xen-devel] Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
>
> . snip ..
> >  static void xen_vcpu_setup(int cpu)
> >  {
> > @@ -1057,6 +1111,8 @@ static __init void
> xen_post_allocator_init(void)
> >  	SetPagePinned(virt_to_page(level3_user_vsyscall));
> >  #endif
> >  	xen_mark_init_mm_pinned();
> > +
> > +/*	xen_return_unused_memory(); */
> 
> Should this be commented out? Or do you plan to provide another
> patch to enable this after extensive testing?
> 

Ups.....This should not be commented out. I will resent the patch with
correct (uncommented) line.
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel

-- 
Miroslav Rezanina
Software Engineer - Virtualization Team - XEN kernel


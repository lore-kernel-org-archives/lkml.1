Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXJAQqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXJAQqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXJAQqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:46:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:1448 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbXJAQqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:46:39 -0400
Message-ID: <fa686aa40710010946s55e3cf19w1e91a4e5c48b3dd6@mail.gmail.com>
Date: Mon, 1 Oct 2007 10:46:38 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH 6/6] Xilinxfb: add of_platform bus binding
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       akonovalov@ru.mvista.com, linuxppc@ozlabs.org, adaplas@gmail.com
In-Reply-To: <961aa3350710010942y42aef8eax6fb54354184b4cc1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net>
	 <20071001155759.6114.29143.stgit@trillian.cg.shawcable.net>
	 <961aa3350710010942y42aef8eax6fb54354184b4cc1@mail.gmail.com>
X-Google-Sender-Auth: ea49be6302f4ac27
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 2007/10/2, Grant Likely <grant.likely@secretlab.ca>:
>
> >  static int __init
> >  xilinxfb_init(void)
> >  {
> > -       /*
> > -        * No kernel boot options used,
> > -        * so we just need to register the driver
> > -        */
> > +       int rc;
> > +       rc = xilinxfb_of_register();
> > +       if (rc)
> > +               return rc;
> > +
> >         return platform_driver_register(&xilinxfb_platform_driver);
>
> Is it better to add error handling for platform_driver_register()?

Right, good catch.  I'll fix that

Thanks!
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195

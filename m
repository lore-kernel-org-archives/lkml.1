Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbXI3XeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbXI3XeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXI3XeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:34:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:65169 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbXI3XeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:34:00 -0400
Message-ID: <fa686aa40709301633q32c7bd9epf07b5a78acb4380e@mail.gmail.com>
Date: Sun, 30 Sep 2007 17:33:55 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Grant Likely" <grant.likely@secretlab.ca>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       axboe@kernel.dk
Subject: Re: [PATCH v2 2/6] Sysace: Use the established platform bus api
In-Reply-To: <20070930230557.GA17654@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
	 <20070930225707.2476.24080.stgit@trillian.cg.shawcable.net>
	 <20070930230557.GA17654@infradead.org>
X-Google-Sender-Auth: 92abad8dbf0b57ed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Sep 30, 2007 at 04:57:09PM -0600, Grant Likely wrote:
> > +     if ((rc = platform_driver_register(&ace_platform_driver)) != 0)
> > +             goto err_plat;
>
>         rc = platform_driver_register(&ace_platform_driver);
>         if (rc)
>                  goto err_plat;
>
> please.

Okay, will do.

>
> > +      err_plat:
> > +     unregister_blkdev(ace_major, "xsysace");
> > +      err_blk:
>
> labels should be indented zero or one space, but not more.

scripts/Lindent does this.  Originally, I *didn't* have my labels
indented.  :-)   Does Lindent need to be fixed?

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195

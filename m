Return-Path: <linux-kernel-owner+w=401wt.eu-S1760806AbZDSMlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806AbZDSMlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 08:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbZDSMkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 08:40:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47981 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618AbZDSMkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 08:40:45 -0400
Date: Sun, 19 Apr 2009 21:39:13 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Denis V. Lunev" <den@openvz.org>
Subject: Re: + mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240070195.29546.3.camel@iris.sw.ru>
References: <20090418152635.125D.A69D9226@jp.fujitsu.com> <1240070195.29546.3.camel@iris.sw.ru>
Message-Id: <20090419213812.FFC5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> already fixed by Andrew by 
>   mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix

Oh, thanks.

 - kosaki

> 
> > ------------------------------------------------------
> > Subject: mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix
> > From: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: Denis V. Lunev <den@openvz.org>
> > Cc: Randy Dunlap <randy.dunlap@oracle.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/mtd/mtdcore.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff -puN
> drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix drivers/mtd/mtdcore.c
> > ---
> a/drivers/mtd/mtdcore.c~mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix
> > +++ a/drivers/mtd/mtdcore.c
> > @@ -48,7 +48,7 @@ static LIST_HEAD(mtd_notifiers);
> >   */
> >  static void mtd_release(struct device *dev)
> >  {
> > -     dev_t index = MTD_DEVT(dev_to_mtd(dev));
> > +     dev_t index = MTD_DEVT(dev_to_mtd(dev)->index);
> >  
> >       /* remove /dev/mtdXro node if needed */
> >       if (index)
> 




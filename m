Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZHKQtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZHKQtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZHKQtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:49:42 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4278 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbZHKQtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:49:41 -0400
Subject: Re: [PATCH 12/14] scsi: use printk_once
From: Joe Perches <joe@perches.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <1250008813.4301.55.camel@mulgrave.site>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
	 <1249847649-11631-13-git-send-email-marcin.slusarz@gmail.com>
	 <1250008813.4301.55.camel@mulgrave.site>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 09:49:38 -0700
Message-Id: <1250009378.8895.425.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 11:40 -0500, James Bottomley wrote:
> On Sun, 2009-08-09 at 21:54 +0200, Marcin Slusarz wrote:
> > --- a/drivers/scsi/cxgb3i/cxgb3i_init.c
> > +++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
> > @@ -43,12 +43,7 @@ static struct cxgb3_client t3c_client = {
> >   */
> >  static void open_s3_dev(struct t3cdev *t3dev)
> >  {
> > -	static int vers_printed;
> > -
> > -	if (!vers_printed) {
> > -		printk(KERN_INFO "%s", version);
> > -		vers_printed = 1;
> > -	}
> > +	printk_once(KERN_INFO "%s", version);
> 
> There's really no point to this beyond code churn.  Both patterns are
> correct uses so conversion buys us nothing.

Standards are for hacks.  Stasis is the best policy.
Using patterns isn't worth the electron movement.
Code shortening and readability?  Humbug.



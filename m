Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZKQQSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZKQQSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZKQQSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:18:46 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37989 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZKQQSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:18:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=afIp4TFSLZOOfLDWdYzGyS2zJgY/nKV0Y9sfs4qiLDYheQOdlAxiF+CiBV5j229d+P
         bd5XgcjwP0yZoDlGtTd+Xg7f27Z9l1LdgKV8npa6P5oJvsG+vJFbFFSO1DYIoM70Wt0h
         LBxlQLJ0XwBQod6bimS9ns1p2hCpFRv25epaQ=
Date: Tue, 17 Nov 2009 19:18:44 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] wm831x-backup: Remove unused variables
Message-ID: <20091117161844.GA10453@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20091117154449.3801.43579.stgit@localhost.localdomain>
 <20091117160616.GA21302@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091117160616.GA21302@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 04:06:17PM +0000, Mark Brown wrote:
> On Tue, Nov 17, 2009 at 03:44:54PM +0000, Alan Cox wrote:
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Adding Anton since this is one for his tree.

Applied, thanks.

> > ---
> > 
> >  drivers/power/wm831x_backup.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > 
> > diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
> > index f181076..bf4f387 100644
> > --- a/drivers/power/wm831x_backup.c
> > +++ b/drivers/power/wm831x_backup.c
> > @@ -164,7 +164,7 @@ static __devinit int wm831x_backup_probe(struct platform_device *pdev)
> >  	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
> >  	struct wm831x_backup *devdata;
> >  	struct power_supply *backup;
> > -	int ret, irq, i;
> > +	int ret;
> >  
> >  	devdata = kzalloc(sizeof(struct wm831x_backup), GFP_KERNEL);
> >  	if (devdata == NULL)
> > 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

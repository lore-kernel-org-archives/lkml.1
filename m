Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYJXOd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYJXOd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYJXOdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:33:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYJXOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:33:18 -0400
Date: Fri, 24 Oct 2008 12:33:15 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
       linux-kernel@vger.kernel.org, airlied@linux.ie, perex@perex.cz,
       alan-jenkins@tuffmail.co.uk
Subject: Re: [PATCH] Check fops_get() return value
Message-ID: <20081024123315.5ca3bc83@pedra.chehab.org>
In-Reply-To: <s5hzll41xgf.wl%tiwai@suse.de>
References: <200810161502.41159.laurent.pinchart@skynet.be>
	<s5hzll41xgf.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 15:28:00 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> >  
> >  	old_fops = filp->f_op;
> >  	filp->f_op = fops_get(&dev->driver->fops);
> > +	if (filp->f_op == NULL) {
> 
> I think the more standard style is
> 
>  if (!file->fop) {

Yes. This seems a good cleanup to the patch.

> 
> Except for that minor issue, it looks good to me.
> In any case,
> 
> Acked-by: Takashi Iwai <tiwai@suse.de>

You have my ack also.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Cheers,
Mauro

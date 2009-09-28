Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZI1RC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZI1RC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZI1RCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:02:55 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59075 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZI1RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w4a1Of2GvkDuKLjjPcm7t3sVWr9CJZcWfo2vNFttEmmyMSawjUGogMPF3Caq4OEaZH
         /+GzPIMB5oC2azgxvaxDQLDPk0SxGHJH7u7QfMaTeLwW8gfs7bvJdG8SXKaKClERMIRC
         1qZ7qXtxZwX7weqtrEuUeXY16F+ihS8Ok6rPM=
Date: Mon, 28 Sep 2009 10:02:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sebastian Frei <dr.nop@gmx.net>
Cc: mitr@volny.cz, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] wistron_btns.c: Add DMI entry for Medion WIM2030 laptop
Message-ID: <20090928170251.GF21455@core.coreip.homeip.net>
References: <200909191243.09243.dr.nop@gmx.net> <1253366810.6699.56.camel@desktop> <200909191655.54654.dr.nop@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909191655.54654.dr.nop@gmx.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 04:55:54PM +0200, Sebastian Frei wrote:
> Am Samstag, 19. September 2009 15:26:50 schrieb Daniel Walker:
> > On Sat, 2009-09-19 at 12:43 +0200, Sebastian Frei wrote:
> > > This patch adds a DMI entry for the Medion WIM2030 laptop.
> > >
> > > Signed-off-by: Sebastian Frei <dr.nop@gmx.net>
> > >
> > > --- linux-2.6.31.orig/drivers/input/misc/wistron_btns.c
> > > +++ linux-2.6.31/drivers/input/misc/wistron_btns.c
> > > @@ -669,6 +669,15 @@
> > >         },
> > >         {
> > >                 .callback = dmi_matched,
> > > +               .ident = "Medion MD 42200",
> > > +               .matches = {
> > > +                       DMI_MATCH(DMI_SYS_VENDOR, "Medion"),
> > > +                       DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2030"),
> > > +               },
> > > +               .driver_data = keymap_fs_amilo_pro_v2000
> > > +       },
> > > +       {
> > > +               .callback = dmi_matched,
> > >                 .ident = "Fujitsu N3510",
> > >                 .matches = {
> > >                         DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
> > 
> > Form email below (your the second person to do this today),
> > 
> > Your patch is whitespace damaged .. All the tabs have been removed from
> > your code, and the context code in the patch. That usually means the
> > patch can't be applied .. It can happen when you X copy&paste the patch
> > into an email. If your using quilt you can use "quilt mail" , or have
> > your mailer "insert text file" instead of copy&paste.
> > 
> > Daniel
> > 
> Next try, this time with tab stops:
> 
> Signed-off-by: Sebastian Frei <dr.nop@gmx.net>
> 

Applied, thanks Sebastian.

-- 
Dmitry

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZHUDoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZHUDoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 23:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZHUDog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 23:44:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:22214 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZHUDof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 23:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=o0ah6M0sFkBHXaXFROch5l3Me3rsOqNy1DVgez7AZSJ/oO2YCfVAx5MiBH9mKsNm5I
         HnWPK03N49HjXGi5qul+GYGYvHWTGq6hvJEGVPOCrOEVrFYdK/mshlZbSYXJ67hU/g1H
         HOjN925A9z9en/KcBQ9PVkVRVQGPiBAoL9WEA=
Date: Thu, 20 Aug 2009 20:44:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] i8042 - bypass AUX IRQ delivery test on laptops
References: <20090814071438.6C860526EC9@mailhub.coreip.homeip.net> <alpine.LRH.2.00.0908181516240.2744@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0908181516240.2744@twin.jikos.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090821041601.DF597526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 03:16:29PM +0200, Jiri Kosina wrote:
> On Thu, 13 Aug 2009, Dmitry Torokhov wrote:
> 
> > @@ -641,7 +643,7 @@ static int __devinit i8042_check_aux(void)
> >   * used it for a PCI card or somethig else.
> >   */
> >  
> > -	if (i8042_noloop || aux_loop_broken) {
> > +	if (i8042_noloop || i8042_bypass_aux_irq_test || aux_loop_broken) {
> 
> I guess some entries could then be nuked from i8042_dmi_noloop_table[]?
> 

I will have to try and locate the dmidecode outputs in mu inbox - some
of them might not have the proper chassis type set up.

-- 
Dmitry

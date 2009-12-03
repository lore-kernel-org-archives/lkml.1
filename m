Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbZLCHPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbZLCHPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZLCHPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:15:07 -0500
Received: from mail-pz0-f184.google.com ([209.85.222.184]:47207 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZLCHPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:15:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nzx6YmwseBSy1p1rshLtqekw0kaOqX6CCMgnqssHTNdRHapKRZhxXyHvumi1d0aDy1
         Vd7sWGGUV0Lm3EYhZ4IwRuEc2sIiF47neKbw9Kvg3/DFDJPn8LzDZemzXNbZrfy8963e
         L9wZDt8qjmhEEULjBtDg3Y0svCd5yFEGcDNgo=
Date: Wed, 2 Dec 2009 23:15:07 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: liu pf <kernelfans@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Should we use preempt_disable() in sleep_on_common()?
Message-ID: <20091203071507.GJ9121@core.coreip.homeip.net>
References: <563a732e0912022249y1e831c6cv7f2d5d376b8a5f63@mail.gmail.com> <20091202230746.611f7fc5@infradead.org> <20091203071244.GI9121@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203071244.GI9121@core.coreip.homeip.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 11:12:44PM -0800, Dmitry Torokhov wrote:
> On Wed, Dec 02, 2009 at 11:07:46PM -0800, Arjan van de Ven wrote:
> > On Thu, 3 Dec 2009 14:49:14 +0800
> > liu pf <kernelfans@gmail.com> wrote:
> > 
> > > Hi:
> > > 
> > > I am puzzled with the following scenario. Could anyone enlighten me?
> > 
> > 
> > sleep_on family of APIs is very racy and just cannot be used correctly;
> > I'm not surprised that there's a preempt race in it, but trust me, it's
> > not the biggest race... never ever use these APIs!!!
> > 
> > 
> 
> BTW, why do we still have them? I checked couple and they don't seem to
> be used...
> 

Ah, my bad, I now see interruptible_sleep_on used all over drivers/char...

-- 
Dmitry

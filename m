Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYDBRpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYDBRpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYDBRpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:45:04 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:12113 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561AbYDBRpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:45:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LLQgalb+ldSmCumNoOJIcyWgI9VDidio85ytPfl6YKHR6TOuWFhxBQqoyyqbW5n36SIG8PTunCbNBzoXPwyaWYyyCoo5JifHfU5bn6TE2cz+SVKc6UyDLE9OZrY4wJiYTEkNDmZyXNeEP6IYJ9PO+gIBV28CKiAhOHiHod09Ir0=
Date: Wed, 2 Apr 2008 13:44:56 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Balaji Rao <balajirrao@gmail.com>
Cc: Yanko Kaneti <yaneti@declera.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
Message-ID: <20080402134351.ZZRA012@mailhub.coreip.homeip.net>
References: <1205775229.25146.11.camel@indigo.declera.com> <200804022038.33245.balajirrao@gmail.com> <20080402113043.ZZRA012@mailhub.coreip.homeip.net> <200804022300.14164.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804022300.14164.balajirrao@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 11:00:13PM +0530, Balaji Rao wrote:
> On Wednesday 02 April 2008 09:03:28 pm Dmitry Torokhov wrote:
> > Hi Blaji,
> > 
> > On Wed, Apr 02, 2008 at 08:38:33PM +0530, Balaji Rao wrote:
> > > 
> > > Coincidentally even I hit upon this bug a couple of days ago after enabling 
> > > HPET in my BIOS. A quick check told me that IRQ 12 which the patch assigns to 
> > > the HPET device is used by the PS/2 mouse as well. This makes the mouse 
> > > inactive.
> > > 
> > > I am working on this.. I am not sure if the PS/2 code is misbehaving though..
> > >
> > 
> > Normally IRQ12 can not be shared on X86 if PS/2 mouse is present.
> > If PCI side tries to grab the IRQ then ISA (legacy) side will never
> > see its interrupts coming.
> > 
> OK. So, I need to specifically check for IRQ12 being assigned and avoid it ?
> 

Yeah.. I think there are other legacy IRQs that should be avoided as well.
I am pretty sure Ingo would have a better idea which they are.

-- 
Dmitry

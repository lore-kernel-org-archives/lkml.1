Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYICOU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYICOU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYICOUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:20:51 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:38992 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYICOUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dtAEYAAq5wHGQwdcZqgyA/0oRO8czi7CIjGMlb0/Jdg14IFu2rv/xcI6PQQY15xw+p
         L7UeKsBoGo9HnSvYQ/0Vm9PIR4/4P33IHUTBojcJB5d0UdhPj1fvkM7c0SEtFNWzKJc4
         AiepikrtqNndahunIb51esRYIgknoAMwsuRkI=
Date: Wed, 3 Sep 2008 10:20:41 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Daniel Barkalow <barkalow@iabervon.org>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
Message-ID: <20080903101947.ZZRA012@mailhub.coreip.homeip.net>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 01:50:35PM +0200, Jiri Kosina wrote:
> On Tue, 2 Sep 2008, Dmitry Torokhov wrote:
> 
> > I guess we could use System's product name to differentiate between 
> > Cristopher's and Daniel's boards. Although I must admit it is the very 
> > first time when I see a box that behaves better with active mux. DOes 
> > Vista use active mux nowadays? Because if it is not then I bet there is 
> > (or shortly will be) a BIOS update fixing legacy mode on Daniel's box.
> 
> I guess so, yes.
> 
> On the other hand, this might also be viewed as regression (we made 
> Daniel's hardware behave worse with recent kernel than it did before), so 
> I think we still would like to have this fixed. What about the patch 
> below, adding the match on System's product name, as you suggested? 
> Thanks.
> 

I agree. Daniel, could you please try the patch to make sure it
restores the previous behavior for you and I will push it through.

Thanks!

-- 
Dmitry

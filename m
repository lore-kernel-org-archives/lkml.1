Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbXJWXyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbXJWXyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbXJWXyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:54:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbXJWXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:54:21 -0400
Date: Tue, 23 Oct 2007 16:53:49 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Dave Jones <davej@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Adam Jackson <ajax@redhat.com>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
Message-ID: <20071023165349.6c9bf853@freepuppy.rosehill>
In-Reply-To: <471E7DCA.9030700@intel.com>
References: <11931515302013-git-send-email-ajax@redhat.com>
	<471E1ECD.80002@intel.com>
	<1193156487.26974.39.camel@localhost.localdomain>
	<471E2AD0.1000500@intel.com>
	<471E5C21.8030908@garzik.org>
	<20071023212026.GF7793@redhat.com>
	<471E7DCA.9030700@intel.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 16:03:38 -0700
"Kok, Auke" <auke-jan.h.kok@intel.com> wrote:

> Dave Jones wrote:
> > On Tue, Oct 23, 2007 at 04:40:01PM -0400, Jeff Garzik wrote:
> > 
> >  > > In any case, this patch should not be merged. We often send it around to users to
> >  > > debug their issue in case it involves eeproms, but merging it will just conceal
> >  > > the real issue and all of a sudden a flood of people stop reporting *real* issues
> >  > > to us.
> >  > 
> >  > Sorry, I disagree.  Just as with e100, if there is a clear way the user 
> >  > can recover their setup -- and Adam says his was effective -- I don't 
> >  > see why we should be denying users the ability to use their own hardware.
> >  
> > Indeed. This is a common enough problem that not including it causes more pain
> > than its worth.  I have two affected boxes myself that I actually thought
> > the hardware was dead before I tried ajax's patch.
> 
> 
> look: You should have reported this to us and you didn't. Now you are using the
> fact that you did not report it as an argument which is out of place.
> 
> why do you say it is common? how often have you seen this and not reported it back
> to our support? are you willingly trying to frustrate this issue?
> 
> 
> Auke

What about a compromise like "ignore_checksum" module option?
That way users with bad checksums wouldn't just ignore the problem (no one reads console logs),
but would have a way to correct the checksum.

There are many reasons would want the ability to fix the problem themselves without
asking Intel.  

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

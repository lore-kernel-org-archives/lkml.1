Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXFDM1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXFDM1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXFDM1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:27:13 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53232 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752427AbXFDM1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:27:13 -0400
Date: Mon, 4 Jun 2007 14:27:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       linux-kernel@vger.kernel.org
Subject: Re: gmail is a bit too popular..
Message-ID: <20070604122716.GU5500@stusta.de>
References: <20070507145555.GG3883@mea-ext.zmailer.org> <alpine.DEB.0.98.0705071101510.6512@sigma.j-a-k-j.com> <20070507153511.GH3883@mea-ext.zmailer.org> <20070508064316.GF4226@stusta.de> <1180954532.25232.252.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1180954532.25232.252.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 11:55:32AM +0100, David Woodhouse wrote:
> On Tue, 2007-05-08 at 08:43 +0200, Adrian Bunk wrote:
> > BTW (not related to gmail):
> > Are there any news regarding the buggy 451 handling in zmailer I'm 
> > reporting again and again that regularly results in every single 
> > linux-kernel message sent to me being delayed by up to 13 hours? 
> 
> Er, you're giving it a 451 response to _every_ message? Why?

Not me, a MTA 4 hops away on the way to me.

And not on _every_ message, it is more like "randomly one out of 
100 messages gets an 451 4.3.2 system not accepting network messages".

That's a perfectly legal behaviour considering that RFC 3463 gives 
"immanent shutdown, excessive load, or system maintenance" (which are 
for the sending MTA equal to "random") as example causes for this 
response.

The problem is really that Zmailer on vger under some circumstances 
never retries to send these emails for days, on one occasion the emails 
bounced after 5 days without any retry.

> dwmw2

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


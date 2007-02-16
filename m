Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXBPRaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXBPRaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXBPRaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:30:10 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59543 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932493AbXBPRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:30:08 -0500
Date: Fri, 16 Feb 2007 18:30:12 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] New driver information
Message-ID: <20070216173012.GQ13958@stusta.de>
References: <20070216135851.GA7939@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216135851.GA7939@zakalwe.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 03:58:51PM +0200, Heikki Orsila wrote:
> I just read
> 
> 	http://kerneltrap.org/node/7729
> 
> and it occured to me that it would be informative to have a new device 
> driver macro. The motivation for the new macro would be 4 issues:
> 
> 	* Is it possible to get specifications for the device?
> 	* If yes, under what terms? (nda, public)
> 	* Where to get public specs?
> 	* How many closed and open drivers in the Linux source tree?
> 
> I suggest to add following macro:
> 
> MODULE_SPECIFICATION(terms, source);
> 
> where "terms" is one of
> 
>  * MODULE_SPEC_ANY_PARTY_NDA
> 	- specification available to any party for an NDA
>  * MODULE_SPEC_ANY_PARTY
> 	- specification available in public, or at least available 
> 	  without NDA to any party
>  * MODULE_SPEC_RESTRICTED
> 	- none of the above
> 
> and "source":
> 
>  * contact address for nda specs
>  * any public source for a public specification (http://, email address, 
>    ...)
>  * empty string otherwise
> 
> I realise this macro somewhat circumvents the purpose of Documentation/ 
> directory but the idea is to have a direct 1:1 mapping between drivers 
> and specification sources so that it would be easy to collect statistics 
> of "open" hardware by using grep et al.
> 
> What do you think? Useless annotations or useful information?

Useless, since noone will maintain this information (e.g. an
"email address" might no longer be valid several years from now, or a 
company might change the policies for releaseing information).

And also useless since there doesn't seem to be a serious use case.

> Heikki Orsila

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


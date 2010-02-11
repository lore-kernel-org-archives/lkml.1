Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0BKS2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:28:43 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61181 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0BKS2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:28:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bohTbccd+fxiy6R3G9EXk2RK44G770WEPATY60LM4j9sJLepvzy9UlbffEqwwIfJRY
         v8qdhEFoV1f+Fd6qY/Fbf1igh2py+sYtGFX/XqtHRc2kJ7f3gkoQv45BWF9hoofFi+z1
         Zfh3vvwiyRFODESMORry+oXCjY0IPo6rdI3f0=
Date: Thu, 11 Feb 2010 10:28:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, Bob Rodgers <Robert_Rodgers@dell.com>,
       "lenb@kernel.org" <lenb@kernel.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>,
       Michael Brown <Michael_E_Brown@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>, Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] Add Dell Business Class Netbook LED driver
Message-ID: <20100211182829.GA26659@core.coreip.homeip.net>
References: <4B7078E2.50407@dell.com>
 <1265911154.4689.11.camel@rex>
 <20100211180518.GB26117@core.coreip.homeip.net>
 <20100211180715.GA2147@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211180715.GA2147@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 06:07:15PM +0000, Matthew Garrett wrote:
> On Thu, Feb 11, 2010 at 10:05:19AM -0800, Dmitry Torokhov wrote:
> 
> > Or stuck it in dell-wmi.c...
> 
> I'd prefer not to put it in dell-wmi. There's no logical association 
> between it and the rest of the code there, so it'd just be overhead on 
> the majority of systems. With the exception of cases where the event and 
> functional interfaces are different GUIDs, I'd prefer a one GUID per 
> driver model.
> 

This is an opposite direction form the rest of the platform drivers
which tend to combine functionality on per-vendor basis in one driver.

I'd say that in this case with this LED driver overhead on DELL systems
not supportinfg it is miniscule. The benefit is that all vendor-specific
sub-devices are children of one parent platform device.

-- 
Dmitry

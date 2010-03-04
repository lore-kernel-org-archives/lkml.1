Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0CDX1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:27:13 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:56489 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756511Ab0CDX1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:27:11 -0500
Subject: Re: [git pull] drm request 3
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       Stephane Marchesin <stephane.marchesin@gmail.com>,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <alpine.LFD.2.00.1003041507070.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	 <20100304190450.GA23807@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
	 <20100304192524.GA24253@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>
	 <20100304195302.GA24856@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
	 <6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com>
	 <alpine.LFD.2.00.1003041449380.3751@localhost.localdomain>
	 <21d7e9971003041503p726ecbebi4b0b97854c5824de@mail.gmail.com>
	 <alpine.LFD.2.00.1003041507070.3751@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 05 Mar 2010 00:27:03 +0100
Message-ID: <1267745223.3849.4176.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 15:19 -0800, Linus Torvalds wrote: 
> 
> What would happen if I changed DRIVER_PATCHLEVEL to 1 for the i915 driver? 

Nothing. :) Only the major version is supposed to signify outright
incompatibility, the minor version signifies backwards compatibility
within the same major version, and the patchlevel has no impact on the
interface. All the other drivers are basically following this, only
nouveau is abusing the patchlevel as a major version for reasons beyond
me.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer

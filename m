Return-Path: <linux-kernel-owner+w=401wt.eu-S1763433AbYF3UYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763433AbYF3UYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYF3UYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:24:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:9726 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYF3UYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LGv3na7vWCPhtjDXzUxelR35nTH4XNuIK7b1y9Fkwrl+rQhMyLv4vlcmmvcde4CiEp
         bgA1Ivh793+guk9HcbUw4y2M7nz/vWglT238SbOaLC3KJhLgU+3Gco+W8MRJrbAeUswU
         bKEwKKW30C5R3egW2dPkogQ6nOi6A7Hoy9ilg=
Date: Mon, 30 Jun 2008 16:24:09 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Cc: Alastair Bridgewater <nyef_sbcl@lisphacker.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: Add support for eGalax TouchKit USB touchscreen
	used on HP tx1305us
Message-ID: <20080630162327.ZZRA012@mailhub.coreip.homeip.net>
References: <200806281719.16837.daniel.ritz-ml@swissonline.ch> <48668070.3040902@lisphacker.com> <20080630112020.ZZRA012@mailhub.coreip.homeip.net> <200806302218.37165.daniel.ritz-ml@swissonline.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806302218.37165.daniel.ritz-ml@swissonline.ch>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 10:18:36PM +0200, Daniel Ritz wrote:
> On Monday 30 June 2008 17:23:35 Dmitry Torokhov wrote:
> > Hi Alastair,
> > 
> > On Sat, Jun 28, 2008 at 02:18:24PM -0400, Alastair Bridgewater wrote:
> > >       bInterfaceClass         3 Human Interface Devices
> > >       bInterfaceSubClass      1 Boot Interface Subclass
> > >       bInterfaceProtocol      2 Mouse
> > 
> > I think we can try to make usbtouchscreen ignore eGalaxes with
> > interface class set to HID?
> > 
> 
> yeah, i was thinking of that too...something like the attached?
> it's completely untested, so no signed-off-by yet...
> 

Yeah, that looks nice. If both you guys could test it it'd be grand.

Thanks!

-- 
Dmitry

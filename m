Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYGXRAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYGXRAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 13:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYGXRAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 13:00:10 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:50852 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYGXRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rFvgt493xjyujxaw7qjJGV5IC+SJ2GDJofe9jV6nCWGsdiAUbSawR8BG/2+nNvhfxb
         dxp4aI/D+NnpRMaJiLZpV2QEMDZYW7QFoH/+PnDrdHE9zxjY/q7/903cyWOBKVYCW8U5
         ozTY4hqL2hk/tZcU52zTE1rMYAGchmQKPMolQ=
Date: Thu, 24 Jul 2008 13:00:05 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: Enable WM97xx touchscreen sub-drivers by default
Message-ID: <20080724170005.GA7081@anvil.corenet.prv>
References: <1216905308-4723-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1216906867-5058-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20080724065756.55954c35@infradead.org> <20080724142650.GA5234@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724142650.GA5234@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 03:26:51PM +0100, Mark Brown wrote:
> On Thu, Jul 24, 2008 at 06:57:56AM -0700, Arjan van de Ven wrote:
> > Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > 
> > > Currently the support for each WM97xx touchscreen model is compiled
> > > out by default, meaning that the default configuration when the
> 
> > this isn't normally how things are done; Linux is on a "off unless
> > selected or unless it breaks booting" policy nowadays...
> 
> These options only be visible if the user has chosen to build the WM97xx
> touchscreen driver which does the default thing already.  Within the
> context of the driver these options are of the broken boot variety since
> without at least one of them being enabled the driver will do nothing
> except waste resources.
> 
> I really don't think it's sensible for the default configuration of the
> driver to produce something totally non-functional.
> 
> > (and distributions don't follow "default" anyway, so don't worry about
> > that part)
> 
> This change is a direct result of Ubuntu enabling the driver with all
> the controllers compiled out.  This seems like a completely reasonable
> thing for them to do - nothing in Kconfig suggests that it is mandatory
> to enable at least one of the options and the existing default and help
> text both suggest that it should be turned off.

I agree with Mark - since the core driver is disabled by default we
don't burden users who do not want it. However enabling the main
option should produce working driver and people who want to save space
in their custom kernels can disable unneeded sub-options.

Will apply.

-- 
Dmitry

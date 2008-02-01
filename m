Return-Path: <linux-kernel-owner+w=401wt.eu-S1760019AbYBAWh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbYBAWh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbYBAWhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:37:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:47937 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYBAWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:37:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=DG78ip8btP4rSfepwWw6hbD7vh4z5EVrWCFjS49OirVSshtJP9q6iS6oGoQJpHCAkoDuyDzzNeBi2PxlDVzJlhp82REtBTVqiHO8jetNmRqYY/TbSc/brkPaC6nhBOshKJt8nerEjqFDxuZLbNVfr79heRBRa6uok6zph0etifA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] Use on-board instead of built-in in config options
Date: Fri, 1 Feb 2008 22:49:22 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <200801262043.17739.bzolnier@gmail.com> <200801262208.28859.bzolnier@gmail.com> <200801271620.01629.elendil@planet.nl>
In-Reply-To: <200801271620.01629.elendil@planet.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802012249.22848.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Frans Pop wrote:
> On Saturday 26 January 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Saturday 26 January 2008, Jan Engelhardt wrote:
> > > On Jan 26 2008 21:31, Frans Pop wrote:
> > > >>  config BLK_DEV_IDE_PMAC
> > > >> -       bool "Builtin PowerMac IDE support"
> > > >> +       tristate "Builtin PowerMac IDE support"
> >
> > this change is no-op at the moment because the next Kconfig line is:
> >
> > 	depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y
> >
> > [ PPC-specific IDE host drivers are still a special case because they are
> >   using ppc_ide_md architecture hooks instead of doing proper host driver
> >   initialization sequence - to be fixed after adding warm-plug support...
> > ]
> >
> > > >This does not seem to make sense: if the option is now tristate, it is
> > > > no longer "Builtin", so probably s/Builtin // in the description.
> > >
> > > Or something like s/Builtin/Onboard/;
> 
> I did not even consider that meaning of built-in, but that does seem more 
> descriptive.
> 
> > Please send a patch.
> 
> Of course :-)
> 
> ---
> From: Frans Pop <elendil@planet.nl>
> 
> To avoid confusion between 'built-in' drivers and 'on-board'
> controllers, consistently use the term 'on-board' for controllers.
> 
> Minor line-wrapping improvements in descriptions for config options.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>

applied, thanks

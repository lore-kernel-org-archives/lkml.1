Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYDWPuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYDWPuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYDWPui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:50:38 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:54143 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYDWPuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mp09hHJ39IVBrjTRIS0L9mMXVoPN93Y4zNrj7SW1o+p4PVAMOAoI8hAFGZjjp7HY6LDAm5KuvJlNYdT/fnvXYF0IMVIubbDDypKSyrvIeIsbFHL6gPDekz/MtzLj8iDk26YyKlmuUg0TQ3S7B1qa0JjVQBIpReTPUnXAmHxzFGs=
Message-ID: <87a5b0800804230850y4d577ff2taf1689f4af26b274@mail.gmail.com>
Date: Wed, 23 Apr 2008 16:50:36 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Kyle McMartin" <kyle@mcmartin.ca>
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
In-Reply-To: <20080423154038.GL19802@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com>
	 <20080422081211.e85989ec.randy.dunlap@oracle.com>
	 <87a5b0800804220816y72a7f4f9gec2111df08a1a57f@mail.gmail.com>
	 <20080422152426.GG19802@phobos.i.cabal.ca>
	 <87a5b0800804220834q4d6daec1x4146d211115ab5c@mail.gmail.com>
	 <20080422153849.GH19802@phobos.i.cabal.ca>
	 <87a5b0800804230736k340e7fe9mffbd72b5b8164015@mail.gmail.com>
	 <20080423154038.GL19802@phobos.i.cabal.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 4:40 PM, Kyle McMartin <kyle@mcmartin.ca> wrote:
> On Wed, Apr 23, 2008 at 03:36:23PM +0100, Will Newton wrote:
>  > +config ARCH_HAS_SYS_SYSFS
>  > +     bool
>  > +     default y
>  > +
>  >  source "init/Kconfig"
>  >
>
>  Sorry, I meant something more like
>
>
>  config ARCH_HAS_SYS_SYSFS
>         def_bool !BLACKFIN
>         help
>           Obsolete sys_sysfs syscall
>
>  in init/Kconfig
>
>  But, it's your patch, you can do it however you like. :)

That's definitely shorter - but it feels a bit more like #ifdef
CONFIG_BLACKFIN which is explicitly what I don't want to do, because
I'm not actually interested in blackfin. ;-)

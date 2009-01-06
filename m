Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZAFPE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZAFPE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZAFPEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:04:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZAFPEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:04:46 -0500
Date: Tue, 6 Jan 2009 16:04:44 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mike Travis <travis@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Cliff Wickman <cpw@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86: make UV support optional
Message-ID: <20090106150444.GI16738@wotan.suse.de>
References: <20090106060348.GA16738@wotan.suse.de> <20090106143330.GB18913@sgi.com> <49637090.8010501@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49637090.8010501@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 06:54:08AM -0800, Mike Travis wrote:
> Jack Steiner wrote:
> > On Tue, Jan 06, 2009 at 07:03:48AM +0100, Nick Piggin wrote:
> >> UV is fairly rare.... and much of the support is already there to cope with
> >> 32-bit builds. So this makes sense I think.
> >>
> > 
> > 
> > Looks ok to me. One suggestion though. There is a MAXSMP config
> > option. I would suggest enabling UV if MAXSMP is enabled. This
> > will help ensure that UV is tested more frequently & may minimize
> > regressions.
> > 
> > 
> > --- jack
> 
> Nick - would you add something like this to your patch?  Thanks! Mike
> ---
> Subject: x86: enable UV when MAXSMP is configured.
> 
> We want UV code to be tested even for non-UV architectures.  Enabling
> MAXSMP specifies "maximizing the system capabitlity" and UV is one of
> these methods.  Also helps distros select the correct config options
> for their default configurations.

I don't really follow. The config option I added is very visible and
clear, isn't it? I don't think MAXSMP means that, otherwise it would
basically be allyesconfig.

I wouldn't object to have a platform types menu like the processor
types one. Or a generic architecture checkbox to select some of
these things together.


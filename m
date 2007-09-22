Return-Path: <linux-kernel-owner+w=401wt.eu-S1762166AbXIVG4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762166AbXIVG4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 02:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbXIVGz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 02:55:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59153 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917AbXIVGz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 02:55:57 -0400
Date: Sat, 22 Sep 2007 08:57:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
       oliver.pntr@gmail.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/50] x86: add cpu codenames for Kconfig.cpu
Message-ID: <20070922065724.GA26550@uranus.ravnborg.org>
References: <200709221231.836138000@suse.de> <20070921223202.2504813DCD@wotan.suse.de> <20070921224539.GD8127@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921224539.GD8127@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 06:45:39PM -0400, Dave Jones wrote:
> On Sat, Sep 22, 2007 at 12:32:02AM +0200, Andi Kleen wrote:
> 
> 
>  > +	  Select this for:
>  > +	    Pentiums (Pentium 4, Pentium D, Celeron, Celeron D) corename:
>  > +		-Willamette
>  > +		-Northwood
>  > +		-Mobile Pentium 4
>  > +		-Mobile Pentium 4 M
>  > +		-Extreme Edition (Gallatin)
>  > +		-Prescott
>  > +		-Prescott 2M
>  > +		-Cedar Mill
>  > +		-Presler
>  > +		-Smithfiled
>  > +	    Xeons (Intel Xeon, Xeon MP, Xeon LV, Xeon MV) corename:
>  > +	    	-Foster
>  > +		-Prestonia
>  > +		-Gallatin
>  > +		-Nocona
>  > +		-Irwindale
>  > +		-Cranford
>  > +		-Potomac
>  > +		-Paxville
>  > +		-Dempsey
> 
> This seems like yet another list that will need to be perpetually
> kept up to date, and given 99% of users don't know the codename
> of their core, just the marketing name, I question its value.

As a bare minimum requirement the list presented here shall use same
names as used in /proc/cpuinfo

On this box I read:

vendor_id	: GenuineIntel
model name	: Pentium III (Coppermine)

This info must be present in Kconfig text (help text) too.
I always have trouble selecting the right CPU before so I welcome this patch
that give me more info - and maybe a bit too much.

	Sam

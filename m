Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbXI3KJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbXI3KJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 06:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXI3KJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 06:09:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbXI3KJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 06:09:39 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] [4/50] x86: add cpu codenames for Kconfig.cpu
Date: Sun, 30 Sep 2007 12:09:35 +0200
User-Agent: KMail/1.9.6
Cc: oliver.pntr@gmail.com, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709221231.836138000@suse.de> <20070921223202.2504813DCD@wotan.suse.de> <20070921224539.GD8127@redhat.com>
In-Reply-To: <20070921224539.GD8127@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301209.35307.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 September 2007 00:45:39 Dave Jones wrote:
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

The problem is that it is hard to distingush Core2 based Xeons
from P4 based Xeons.

There won't be any new Pentium 4 cores so that list should be static.
But yes the C2 list is a little problematic. Will remove that
and just say "family 6" 

Perhaps we should just bit the bullet and add a "optimize for current 
CPU" option.

> 
>  > +	  more info: http://balusc.xs4all.nl/srv/har-cpu.html
>  
> This URL is dead already.
> 
>  >  config MPSC
>  >         bool "Intel P4 / older Netburst based Xeon"
>  >         help
> 
> sidenote: I always wondered what 'PSC' stood for ?

Prescott; the Intel codename for their first x86-64 core.
Rhymes with K8 which was AMD's codename for the same.

Admittedly MCORE2 doesn't fit the pattern, it should have 
been MMEROM. But then when the C2 support was implemented
the Marketing name was already known, which wasn't the case
with the others.

-Andi

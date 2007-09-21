Return-Path: <linux-kernel-owner+w=401wt.eu-S933767AbXIUW5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767AbXIUW5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932893AbXIUWpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:45:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbXIUWpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:45:43 -0400
Date: Fri, 21 Sep 2007 18:45:39 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: oliver.pntr@gmail.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/50] x86: add cpu codenames for Kconfig.cpu
Message-ID: <20070921224539.GD8127@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	oliver.pntr@gmail.com, patches@x86-64.org,
	linux-kernel@vger.kernel.org
References: <200709221231.836138000@suse.de> <20070921223202.2504813DCD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921223202.2504813DCD@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 12:32:02AM +0200, Andi Kleen wrote:


 > +	  Select this for:
 > +	    Pentiums (Pentium 4, Pentium D, Celeron, Celeron D) corename:
 > +		-Willamette
 > +		-Northwood
 > +		-Mobile Pentium 4
 > +		-Mobile Pentium 4 M
 > +		-Extreme Edition (Gallatin)
 > +		-Prescott
 > +		-Prescott 2M
 > +		-Cedar Mill
 > +		-Presler
 > +		-Smithfiled
 > +	    Xeons (Intel Xeon, Xeon MP, Xeon LV, Xeon MV) corename:
 > +	    	-Foster
 > +		-Prestonia
 > +		-Gallatin
 > +		-Nocona
 > +		-Irwindale
 > +		-Cranford
 > +		-Potomac
 > +		-Paxville
 > +		-Dempsey

This seems like yet another list that will need to be perpetually
kept up to date, and given 99% of users don't know the codename
of their core, just the marketing name, I question its value.

 > +	  more info: http://balusc.xs4all.nl/srv/har-cpu.html
 
This URL is dead already.

 >  config MPSC
 >         bool "Intel P4 / older Netburst based Xeon"
 >         help

sidenote: I always wondered what 'PSC' stood for ?

	Dave

-- 
http://www.codemonkey.org.uk

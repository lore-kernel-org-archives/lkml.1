Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbXGWISe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbXGWISe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbXGWISS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:18:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbXGWISR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:18:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Paul Mackerras <paulus@samba.org>, Alan Modra <amodra@bigpond.net.au>,
       David Miller <davem@davemloft.net>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
In-Reply-To: Sam Ravnborg's message of  Monday, 23 July 2007 10:14:35 +0200 <20070723081435.GA4644@uranus.ravnborg.org>
X-Windows: flaky and built to stay that way.
Message-Id: <20070723081814.846B64D058D@magilla.localdomain>
Date: Mon, 23 Jul 2007 01:18:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > -cmd_link_multi-m = $(LD) $(ld_flags) $(LDFLAGS_MODULE) -o $@ $(link_multi_deps)
> > +cmd_link_multi-m = $(cmd_link_multi-y)
> This signel change looks wrong. We do not want to generate a linker
> script for modules.

multi-m has nothing to do with modules, really.  It's just for another
"built-in.o"-style object that happens to be the input for a .ko link
rather than the vmlinux link.  


Thanks,
Roland

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZFYVpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZFYVpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZFYVpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:45:09 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41467 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZFYVpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:45:08 -0400
Date: Thu, 25 Jun 2009 17:43:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in arch/x86/include/asm/boot.h [Was: next cleanup report: 
 "bad" references to CONFIG variables]
In-Reply-To: <20090625192412.GA15823@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0906251739360.23271@localhost>
References: <alpine.LFD.2.00.0906251028270.24694@localhost> <20090625192412.GA15823@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Sam Ravnborg wrote:

> If you continue this then please filter the know false positives.
> For once start ignoring defconfigs.

  point taken.  back at the "badrefs" page:

http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables

i've cleaned up the "arch" categories by removing all matches to
defconfig files, which cuts down the output considerably.

  the "drivers" section will be cleaned similarly shortly.

rday

p.s.  i did notice another false positive when the only references to
a "config" directive is nothing but other "select" directives.  i'll
fix that one of these days.  but it's never going to be perfect.  law
of diminishing returns and all that.

--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbXFMCMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbXFMCMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 22:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbXFMCMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 22:12:39 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33398 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbXFMCMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 22:12:39 -0400
Message-ID: <466F527E.1010106@zytor.com>
Date: Tue, 12 Jun 2007 19:12:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Oleg Verych <olecom@flower.upol.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kbuild-devel] [patch] kbuild: remember ARCH in the object	directory
References: <200705090951.l499pa6G020397@shell0.pdx.osdl.net>	<20070509204613.GA10336@uranus.ravnborg.org>	<1178755780.7286.175.camel@localhost.localdomain>	<E1HxjKu-0004G6-7d@flower>	<20070611125903.GA3933@uranus.ravnborg.org>	<E1Hy3fI-0001Tw-Fy@flower>	<20070612091209.760b5225.randy.dunlap@oracle.com>	<20070612171922.GG7266@flower.upol.cz> <20070612180957.GD15329@uranus.ravnborg.org>
In-Reply-To: <20070612180957.GD15329@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> If we go the "save important parts of the config" I prefer
> something along the suggestion by hpa with a config file.
> The config file should though be named along the lines
> of Kbuild.config and the syntax should be future proof.
> I like the syntax of the .git/config file and
> it should be along these lines.
> 

It's actually derived from the Windows 3.x config file.  I think it's
massive overkill for this purpose; since the variables can be set on the
command line we're not dealing with multiple namespaces, and it would be
better to have a make-like syntax.

	-hpa

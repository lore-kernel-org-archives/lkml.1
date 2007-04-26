Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXDZTiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXDZTiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbXDZTiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:38:05 -0400
Received: from khc.piap.pl ([195.187.100.11]:59307 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbXDZTiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:38:02 -0400
To: Adrian Bunk <bunk@stusta.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Rene Herman <rene.herman@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <20070404170016.453d26f1@the-village.bc.nu>
	<4613D492.2070404@gmail.com> <462C7D74.60003@gmail.com>
	<1177327476.17026.75.camel@localhost.localdomain>
	<Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>
	<462CA764.5080401@gmail.com>
	<20070425181856.42fcfeb4.akpm@linux-foundation.org>
	<463081E5.5010306@gmail.com> <20070426135426.GM3468@stusta.de>
	<20070426084143.1d973c71.randy.dunlap@oracle.com>
	<20070426155205.GN3468@stusta.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 26 Apr 2007 21:37:59 +0200
In-Reply-To: <20070426155205.GN3468@stusta.de> (Adrian Bunk's message of "Thu, 26 Apr 2007 17:52:06 +0200")
Message-ID: <m38xcfhqp4.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> I don't think we want to expose maintainership information to users at 
> all:
> - duplicates information in MAINTAINERS
> - maintainers sometimes disappear
> - the 3 year old kernel of your distribution would contain 3 year old
>   maintainership information

Right. Summary: adding maintainer info to source code and/or
compiled modules doesn't seem to make any sense.

> IMHO the default should be that users report problems with distribution 
> kernels to their distribution and problems with ftp.kernel.org kernels 
> to either linux-kernel or the kernel Bugzilla.

Yep. But it's really easy to miss something in lkml and/or in
more specific lists, and the Bugzilla isn't email. That means
we need a WWW-browseable database, with:
a) maintainers registrations with a simple email verification or
   something like that
b) possibility for registered people to declare they now maintain
   (or not) specific portions of the kernel
c) possibility for anyone to retrieve this information.

Other options?
-- 
Krzysztof Halasa

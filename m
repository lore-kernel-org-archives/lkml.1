Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbXDZWGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbXDZWGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbXDZWGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:06:12 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:43414 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbXDZWGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:06:10 -0400
Message-ID: <4631219D.4060402@gmail.com>
Date: Fri, 27 Apr 2007 00:03:09 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
References: <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com> <462C7D74.60003@gmail.com> <1177327476.17026.75.camel@localhost.localdomain> <Pine.LNX.4.64.0704230748270.25463@localhost.localdomain> <462CA764.5080401@gmail.com> <20070425181856.42fcfeb4.akpm@linux-foundation.org> <463081E5.5010306@gmail.com> <20070426135426.GM3468@stusta.de> <20070426084143.1d973c71.randy.dunlap@oracle.com> <20070426155205.GN3468@stusta.de>
In-Reply-To: <20070426155205.GN3468@stusta.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2007 05:52 PM, Adrian Bunk wrote:

> I don't think we want to expose maintainership information to users at 
> all:

With the point you make about old installed kernel modules having outdated 
information forever you've in fact convinced me that MODULE_MAINTAINER is 
not a good idea. If I decide after some time that I no longer want to be a 
maintainer anymore, I can delete the MODULE_MAINTAINER and/or the entry in 
MAINTAINERS in the current kernel, but I could be getting mail for a long 
time still through old installs.

The problem I still have is that we _do_ expose authorship information, 
generally complete with (an) email address(es), which is the only address 
available from the binary and which is displayed on every invocation of the 
user tool "modinfo". Proper contact information may rather be available from 
a text file off in a source tree somewhere instead, but this information is 
ofcourse going to remain being interpreted as such however one may feel 
about it.

Deleting authorship information can't happen for legal reasons. Not in the 
global "delete them all" sense but also not in a local sense; a maintainer 
doesn't have the right to delete a MODULE_AUTHOR tag but not being able to 
additionally supply contact information _alongside_ that information then 
leaves the confusing message the tag sends as is.

Deleting the email addresses from the MODULE_AUTHOR tag would go some ways 
to fix it; it's then at least clearer that the author is not being displayed 
as a general contact for the driver. It may on the other hand want to remain 
as a legal contact and I only know of "modinfo" as a normal way of listing 
the tags, so even a very minimal solution such as having modinfo supress the 
author tag, or even just any email address in it, would be good enough.

Rene.

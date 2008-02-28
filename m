Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbYB1Qba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbYB1Qba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbYB1QbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:31:22 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15106 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbYB1QbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:31:21 -0500
Date: Thu, 28 Feb 2008 08:30:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kernel-doc: set verbose mode via environment
Message-Id: <20080228083009.5955a7eb.randy.dunlap@oracle.com>
In-Reply-To: <20080227191104.6f166972.akpm@linux-foundation.org>
References: <20080224175358.3202f0d0.randy.dunlap@oracle.com>
	<20080227191104.6f166972.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 19:11:04 -0800 Andrew Morton wrote:

> On Sun, 24 Feb 2008 17:53:58 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Allow setting environment variable "KERNEL_DOC_VERBOSE=1" to enable
> > verbose mode in scripts/kernel-doc.  Useful for getting more
> > info and warnings from kernel-doc.
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  scripts/kernel-doc |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > --- linux-2.6.25-rc3.orig/scripts/kernel-doc
> > +++ linux-2.6.25-rc3/scripts/kernel-doc
> > @@ -247,6 +247,10 @@ my ($function, %function_table,%paramete
> >  my ($type,$declaration_name,$return_type);
> >  my ($newsection,$newcontents,$prototype,$filelist, $brcount, %source_map);
> >  
> > +if (defined($ENV{'KERNEL_DOC_VERBOSE'})) {
> > +	$verbose = "$ENV{'KERNEL_DOC_VERBOSE'}";
> > +}
> > +
> >  # Generated docbook code is inserted in a template at a point where
> >  # docbook v3.1 requires a non-zero sequence of RefEntry's; see:
> >  # http://www.oasis-open.org/docbook/documentation/reference/html/refentry.html
> 
> Shouldn't this be, err, documented somewhere?

I did think about that.  I was still wondering where to add it.

> I'd have expected to obtain this functionality by running `make V=1 foodocs'?

Sam, any thoughts on Makefile passing "-v" to scripts/kernel-doc ?

---
~Randy

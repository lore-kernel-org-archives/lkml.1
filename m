Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbXEBUuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbXEBUuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993143AbXEBUuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:50:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39904 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXEBUt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:49:56 -0400
Date: Wed, 2 May 2007 13:52:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, tglx@linutronix.de
Subject: Re: [PATCH 2/3] UIO: Documentation
Message-Id: <20070502135237.59a46232.randy.dunlap@oracle.com>
In-Reply-To: <200705021041.35422.hjk@linutronix.de>
References: <20070427224957.GA17967@kroah.com>
	<11777142633770-git-send-email-gregkh@suse.de>
	<20070501164239.00d209c8.randy.dunlap@oracle.com>
	<200705021041.35422.hjk@linutronix.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 10:41:35 +0200 Hans-Jürgen Koch wrote:

> Am Mittwoch 02 Mai 2007 01:42 schrieb Randy Dunlap:
> 
> > > +<title>The Userspace I/O HOWTO</title>
> > 
> > Most of this reads well.  Thanks.
> > A few typo corrections are below...
> 
> Thank you for your work. I generated a new patch that includes all your 
> suggestions and also fixes the build problems.

Hi,
What does your patch apply to, please?  I get patch errors with it.


> [...]
> > 
> > However, it still fails 'make htmldocs' for me.
> > What am I missing?  How did it work for you?
> > My DTD doesn't like to see <varname> inside a <listitem>:
> > 
> > 
> > linux-2.6.21-rc7-mm2/Documentation/DocBook/uio-howto.xml:333: element listitem: validity error : Element listitem content does not follow the DTD, expecting (calloutlist | glosslist | itemizedlist | orderedlist | segmentedlist | simplelist | variablelist | caution | important | note | tip | warning | literallayout | programlisting | programlistingco | screen | screenco | screenshot | synopsis | cmdsynopsis | funcsynopsis | classsynopsis | fieldsynopsis | constructorsynopsis | destructorsynopsis | methodsynopsis | formalpara | para | simpara | address | blockquote | graphic | graphicco | mediaobject | mediaobjectco | informalequation | informalexample | informalfigure | informaltable | equation | example | figure | table | msgset | procedure | sidebar | qandaset | anchor | bridgehead | remark | highlights | abstract | authorblurb | epigraph | indexterm | beginpage)+, got (varname CDATA)
> > 
> > 
> > so I removed most of the <varname>s and still had errors.
> > Any suggestions?
> 
> Yes, this only occurs when the <listitem> content is not surrounded by 
> <para></para>. I fixed that. I also changed the whole thing from
> "article" to "book" as all the other *.tmpl files are books. 
> 
> 
> [...]
> > > <listitem>
> > > +<varname>void *internal_addr</varname>: If you have to access this memory
> > > +region from within your kernel module, you will want to map it internally by
> > > +using something like <function>ioremap_nocache()</function>. Addresses
> > > +returned by this function can not be mapped to user space, so you must not
> > 
> >                              cannot
> 
> Here I also replaced ioremap_nocache() by ioremap(). I just fixed that in
> uio_cif.c and don't want to encourage other people to write the same nonsense.
> 
> Here's my patch, as I said, it should include your fixes as well:
> 
> Index: linux-2.6.22-rc/drivers/uio/uio.c


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYGVEvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYGVEvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYGVEvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:51:41 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25385 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYGVEvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:51:40 -0400
Message-ID: <28878868.1216702283977.JavaMail.oracle@acsmt301.oracle.com>
Date: Mon, 21 Jul 2008 23:51:23 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: michael@ellerman.id.au
Subject: Re: [PATCH] pci kernel-doc fatal error
Cc: jbarnes@virtuousgeek.org, torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
In-Reply-To: <1216693765.8479.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
References: <20080721092718.f15dc1ea.randy.dunlap@oracle.com>
	 <1216681665.7427.9.camel@localhost>
	 <20080721161440.31c97fb8.randy.dunlap@oracle.com> <1216693765.8479.6.camel@localhost>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Original Message ---
> On Mon, 2008-07-21 at 16:14 -0700, Randy Dunlap wrote:
> > On Tue, 22 Jul 2008 09:07:45 +1000 Michael Ellerman wrote:
> > 
> > > On Mon, 2008-07-21 at 09:27 -0700, Randy Dunlap wrote:
> > > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > > 
> > > > Fix kernel-doc comments so that they don't produce errors.
> > > > Also cut some extraneous copy-paste text.
> > > > 
> > > > Error(linhead//drivers/pci/pci.c:1133): duplicate section name 'Description'
> > > > Error(linhead//drivers/pci/pci.c:1189): duplicate section name 'Description'
> > > 
> > > But now the description lines exceed 80 columns, and with longer
> > 
> > Yes, I'm pretty well aware of that.  :(
> > This is one of the places where we tolerate that, while not enjoying it.
> > 
> > This is a request that akpm has also made, and it makes some sense, and it's
> > on my long list of (volunteer) doc work to do...
> 
> Sure.
> 
> > > ps. I did look at changing kerneldoc to do that myself, but whereas
> > > previously I thought I didn't really know perl, now I /know/ I totally
> > > don't know perl ;)
> > 
> > Yes, I understand that comment.  ;)
> > That's part of the problem, of course.
> > I.e., if it were straightforward, it would probably already be done.
> 
> I guess there's also a good reason why the kernel implements
> its own
> doco-from-c-comments extraction tool, rather than using something
> that already exists (doxygen?).

I don't know the history behind it.  I.e., it happened before I began caring
about it.

~Randy


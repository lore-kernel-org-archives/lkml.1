Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbXJAB2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbXJAB2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 21:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXJAB2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 21:28:15 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37670
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750757AbXJAB2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 21:28:14 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Documentation/x86_64/00-INDEX
Date: Sun, 30 Sep 2007 20:28:09 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, vojtech@suse.cz
References: <200709281944.02953.rob@landley.net> <20070930203503.GA9748@one.firstfloor.org>
In-Reply-To: <20070930203503.GA9748@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709302028.09949.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 September 2007 3:35:03 pm Andi Kleen wrote:
> On Fri, Sep 28, 2007 at 07:44:02PM -0500, Rob Landley wrote:
> > From: Rob Landley <rob@landley.net>
> >
> > Add Documentation/x86_64/00-INDEX
>
> What's the point of this file?

It's for http://kernel.org/doc/Documentation/

I have a script that converts each 00-INDEX files into an index.html file, and 
then uses that instead of just a directory listing.  I'm trying to get 
complete coverage (a 00-INDEX file for each directory), although what I 
really need is no directories with _partial_ 00-INDEX files (because then 
using index.html instead of showing the directory listing would hide files).

If you want this directory to be special and _not_ have a 00-INDEX file, 
that's fine by me.  It screws up my 404 link checker, but I can hardwire in 
an exception for you...

> > +boot-options.txt
> > +	- AMD64-specific boot options.
>
> The architecture is not called AMD64 under Linux.

That line was cut and paste from the first line of boot-options.txt.  If you'd 
like to suggest another description, I'm all ears and can update the patch to 
touch boot-options.txt at the same time.

> > +mm.txt
> > +	- Memory layout of x86-64 (4 level page tables, 46 bits physical).
>
> I don't think such details as the 46 bit number should be in an index file.

*shrug*  Ok.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1750966AbXBMRPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966AbXBMRPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXBMRPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:15:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42314 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbXBMRPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:15:33 -0500
X-Greylist: delayed 1372 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 12:15:33 EST
From: Andi Kleen <ak@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH x86 for review III] [1/29] i386: avoid gcc extension
Date: Tue, 13 Feb 2007 17:52:27 +0100
User-Agent: KMail/1.9.5
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       Segher Boessenkool <segher@kernel.crashing.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070212551.664370000@suse.de> <200702131611.15172.arnd@arndb.de> <20070213081023.1fc951ff.randy.dunlap@oracle.com>
In-Reply-To: <20070213081023.1fc951ff.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200702131752.28377.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 17:10, Randy Dunlap wrote:
> On Tue, 13 Feb 2007 16:11:14 +0100 Arnd Bergmann wrote:
> 
> > On Monday 12 February 2007 17:51, Andi Kleen wrote:
> > > setcc() in math-emu is written as a gcc extension statement expression
> > > macro that returns a value.  However, it's not used that way and it's not
> > > needed like that, so just make it a do-while non-extension macro so that we
> > > don't use an extension when it's not needed.
> > > 
> > 
> > The patch looks good but it doesn't match the description any more, since
> > you now use a function...
> 
> Hi Arnd,
> Someone else had that same comment, so I sent a corrected patch
> (description change only) to that mail.

I had already fixed it up

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbXDMTnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbXDMTnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXDMTnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:43:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54259 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbXDMTnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:43:01 -0400
Date: Fri, 13 Apr 2007 21:42:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       "Christopher S. Aker" <caker@theshore.net>,
       "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
Message-ID: <20070413194258.GA26628@one.firstfloor.org>
References: <20070412172845.58bfeff5@the-village.bc.nu> <20070412164251.GC11736@ti88.telemetry-investments.com> <p73ps697agf.fsf@bingen.suse.de> <461EE95A.3090600@theshore.net> <20070412193838.ea98238b.randy.dunlap@oracle.com> <461EF1A1.3070102@theshore.net> <20070413115526.69e61016@the-village.bc.nu> <p73d528799k.fsf@bingen.suse.de> <461F9ABE.6060709@oracle.com> <20070413171727.6a54d80e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413171727.6a54d80e@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 05:17:27PM +0100, Alan Cox wrote:
> > > Here's a patch. It just doesn't do any formatting for the pipe case.
> 
> I don't see a reaosn for removing the formatting features. There are ways
> that can usefully be used, although not many. It's also messier than the
> patch I posted while less functional IMHO.

To make formatting for pipes useful you would need to split arguments.
I chose not to do it because all the information in the format can be gotten
in other ways already -- either from the coredump or from the environment

-Andi

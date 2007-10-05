Return-Path: <linux-kernel-owner+w=401wt.eu-S1762750AbXJEB7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762750AbXJEB7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 21:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759201AbXJEB7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 21:59:34 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38975
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760072AbXJEB7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 21:59:33 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Date: Thu, 4 Oct 2007 20:59:25 -0500
User-Agent: KMail/1.9.6
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Holzheu <holzheu@linux.vnet.ibm.com>,
       Joe Perches <joe@perches.com>,
       Dick Streefland <dick.streefland@altium.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jesse Barnes <jesse.barnes@intel.com>, Arnd Bergmann <arnd@arndb.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Emil Medve <Emilian.Medve@freescale.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>,
       Miguel Ojeda <maxextreme@gmail.com>
References: <1191528247.13580.11.camel@grianne> <20071004131703.25046db9.randy.dunlap@oracle.com>
In-Reply-To: <20071004131703.25046db9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710042059.25721.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2007 3:17:03 pm Randy Dunlap wrote:
> On Thu, 04 Oct 2007 22:04:07 +0200 Vegard Nossum wrote:
> > Description: This patch largely implements the kprint API as previously
> > posted to the LKML and described in Documentation/kprint.txt (see patch).
> >
> > The main purpose of this change is provide a unified logging API to the
> > kernel and at the same time make it easy to add extensions, now and
> > later.
> >
> > My changes and additions are as follows:
>
> $ diffstat -p1 -w70 kprint.patch
...
>  40 files changed, 1660 insertions(+), 72 deletions(-)

I started this thread by posting an idea I had for shrinking the kernel by 
allowing more code to be configured out.  The API change was exactly one new 
parameter, with a direct 1->1 mapping from the old API to the new one, which 
was trivial to convert and which the compiler would catch if you missed one.

The result of the discussion is a patch adding 1600 lines to the kernel, 
without removing anything.

Last I checked, the current prink() worked just fine.  Why is this _not_ the 
dreaded "infrastructure in search of a use"?  What exactly can we _not_ do 
with the current code?  What does this allow us to remove and simplify?

I'm confused about what people are trying to accomplish here...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

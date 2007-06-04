Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXFDJ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXFDJ3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXFDJ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:29:05 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25044 "EHLO
	outbound8-sin-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752711AbXFDJ3D (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:29:03 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: patch-2.6.21.3-rt9 misnamed?
Date: Mon, 4 Jun 2007 11:27:36 +0200
User-Agent: KMail/1.9.6
cc: "Ingo Molnar" <mingo@elte.hu>, "K.R. Foley" <kr@cybsft.com>,
       Linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
References: <465EE33B.4070502@cybsft.com>
 <20070531200109.GA8715@elte.hu> <20070601161111.GM11166@waste.org>
In-Reply-To: <20070601161111.GM11166@waste.org>
MIME-Version: 1.0
Message-ID: <200706041127.37244.joachim.deguara@amd.com>
X-OriginalArrivalTime: 04 Jun 2007 09:28:24.0008 (UTC)
 FILETIME=[B2E02480:01C7A68A]
X-WSS-ID: 6A7D04B120G3965910-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2007 18:11:11 Matt Mackall wrote:
> On Thu, May 31, 2007 at 10:01:09PM +0200, Ingo Molnar wrote:
> > * K.R. Foley <kr@cybsft.com> wrote:
> > > Ingo Molnar wrote:
> > > > * K.R. Foley <kr@cybsft.com> wrote:
> > > >> Ingo,
> > > >>
> > > >> I believe that patch-2.6.21.3-rt9 is misnamed. It applies cleanly to
> > > >> 2.6.21 but seems to contain stuff that is already in 2.6.21.3.
> > > >
> > > > yes - it includes all of 2.6.21.3.
> > > >
> > > > 	Ingo
> > >
> > > So actually it is not really misnamed, it's just done a bit
> > > differently than previous versions. Sorry.
> >
> > yeah. Maybe we should make the 2.6.21.3 -rt patches relative to 2.6.21.3
> > - but that would be one extra patching step for people who already have
> > a 2.6.21 tree. But ... maybe that makes the most sense after all.
>
> Including 2.6.21.3 in your patch will break ketchup.

ketchup already breaks with the current rt9 patch. 

lapdog{rt}$ ketchup -n 2.6-rt
None -> 2.6.21.3-rt9
Unpacking linux-2.6.21.tar.bz2
Applying patch-2.6.21.3.bz2
Applying patch-2.6.21.3-rt9
lapdog{rt}$ head `which ketchup`
#!/usr/bin/python
#
# ketchup 0.9.8
# http://selenic.com/ketchup/wiki

As noted before rt9 is based one 2.6.21 so after ketchup brings the directory 
to 2.6.21.3 then applying rt9 fails.

I would appreciate it if you base the rtX patch on the kernel you list as a 
prefix of that patch.  It helps us that use ketchup and it just makes sense.

-Joachim



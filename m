Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZCESXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZCESXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbZCESXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:23:41 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:34533 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbZCESXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:23:40 -0500
X-BigFish: VPS-36(zz1432R98dR936eQ1805M936fKzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KG1PQS-02-THD-01
Date: Thu, 5 Mar 2009 19:23:18 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: msr architecture debug code
Message-ID: <20090305182318.GE7347@alberich.amd.com>
References: <1236008575.3332.2.camel@localhost.localdomain> <20090302205437.GB14471@elte.hu> <20090305135444.GB7347@alberich.amd.com> <1236262346.2527.3.camel@ht.satnam> <20090305143726.GC7347@alberich.amd.com> <1236268057.2527.23.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1236268057.2527.23.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Mar 2009 18:23:21.0830 (UTC) FILETIME=[770B1860:01C99DBF]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 09:17:37PM +0530, Jaswinder Singh Rajput wrote:
> 
> On Thu, 2009-03-05 at 15:37 +0100, Andreas Herrmann wrote:
> > On Thu, Mar 05, 2009 at 07:42:26PM +0530, Jaswinder Singh Rajput wrote:
> > > On Thu, 2009-03-05 at 14:54 +0100, Andreas Herrmann wrote:
> > > 
> > > > All nice suggestions but why in-kernel?
> > > > 
> > > 
> > > In Kernel Space:
> > > 
> > > We can read/write MSRs and can change the bits and see it effect without
> > > writing any code.
> > 
> > Sorry, I can't (or maybe I don't like to) follow.
> > 
> > (BTW, you don't even need to write C-code. You can use a one-liner in perl
> > or python to seek and read any MSR using /dev/cpu/*/msr.)
> > 
> 
> You are running these commands on shell when every thing is working.
> 
> What you will do if you are not getting the shell and kernel is dumping
> or rebooting before that.

In this case a deep debugfs tree with all the MSR details is not of
use either.


Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632



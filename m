Return-Path: <linux-kernel-owner+w=401wt.eu-S1763437AbXFAVgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763437AbXFAVgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759889AbXFAVgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:36:01 -0400
Received: from outbound-mail-63.bluehost.com ([69.89.21.23]:60308 "HELO
	outbound-mail-63.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759162AbXFAVgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:36:00 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Date: Fri, 1 Jun 2007 14:35:56 -0700
User-Agent: KMail/1.9.6
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org>
In-Reply-To: <20070601211943.GO7217@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706011435.56440.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 1, 2007 2:19:43 Andi Kleen wrote:
> On Fri, Jun 01, 2007 at 02:07:51PM -0700, Jesse Barnes wrote:
> > On Friday, June 1, 2007 2:14:17 Andi Kleen wrote:
> > > Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> > > > (or we get proper PAT support, which I think would make this problem
> > > > go away as well).
> > >
> > > No it won't. If the basic MTRRs for memory are wrong just having PAT
> > > support in drivers (which already exist in a limited form already, just
> > > for UC only) won't change anything.
> >
> > No obviously just using PAT for drivers wouldn't help, I was thinking
> > more of having one PAT type be WB memory, and using it by default for
> > most PTEs
>
> Then the BIOS couldn't override it anymore in case it is needed somewhere.
> e.g. normally we just use normal 2MB direct mappings for the hole
> if there is memory beyond it and the hole doesn't need to be 2MB aligned.
> Just assuming UC for all reserved pages would be also pretty drastic
> and likely result in many 2MB pages being split and using a lot more
> TLB.
>
> > covering normal memory.  If that's not possible, then it seems sensible
> > to
>
> And normally the MTRRs win, don't they (if I remember the table correctly)
> So if the MTRR says UC and PAT disagrees it might not actually help

I didn't check that part of the spec, that might be true.  If so, then we 
really need some sort of MTRR fix no matter what.

Jesse

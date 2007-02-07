Return-Path: <linux-kernel-owner+w=401wt.eu-S965613AbXBGPD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965613AbXBGPD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 10:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161350AbXBGPDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 10:03:55 -0500
Received: from mga05.intel.com ([192.55.52.89]:38766 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965613AbXBGPDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 10:03:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,295,1167638400"; 
   d="scan'208"; a="196802439:sNHT19781090"
Date: Wed, 7 Feb 2007 07:41:33 -0800
From: "Lombard, David N" <dnlombar@ichips.intel.com>
To: Horms <horms@verge.net.au>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, fastboot@osdl.org,
       Judith Lebzelter <judith@osdl.org>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Fastboot] [ PATCH ] fix to documentation for kexec
Message-ID: <20070207154133.GA29525@nlxdcldnl2.cl.intel.com>
Mail-Followup-To: Horms <horms@verge.net.au>,
	"Robert P. J. Day" <rpjday@mindspring.com>, fastboot@osdl.org,
	Judith Lebzelter <judith@osdl.org>, ebiederm@xmission.com,
	linux-kernel@vger.kernel.org
References: <20070201181955.GE5825@shell0.pdx.osdl.net> <Pine.LNX.4.64.0702011324050.16833@CPE00045a9c397f-CM001225dbafb6> <20070207073316.GF26314@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207073316.GF26314@verge.net.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 04:33:16PM +0900, Horms wrote:
> On Thu, Feb 01, 2007 at 01:25:04PM -0500, Robert P. J. Day wrote:
> > On Thu, 1 Feb 2007, Judith Lebzelter wrote:
> > >
> > > -* "init 1" boots the dump-capture kernel into single-user mode without
> > > -  networking. If you want networking, use "init 3."
> > > +* Boot parameter "1" boots the dump-capture kernel into single-user mode
> > > +  without networking. If you want networking, use "3".
> > 
> > i'm not sure you want to totally remove those first two lines, they
> > appear to talk about getting to run level 1 *from a running system*.
> 
> I think that it is refering to a kernel command line parameter,
> not a shell command executed on a running system, so I think the patch
> is correct in that respect.

Agree with removing the "init" word.  A single digit is assumed by the kernel
to be the run level.

Also, given the variability of those values, leave the current documentation
at levels 1 and 3.

BTW, the "init" keyword, *with* a value, specifies an alternate init process
binary, e.g,, the default is "init=/sbin/init"

-- 
David N. Lombard, Intel, Irvine, CA
I do not speak for Intel Corporation; all comments are strictly my own.

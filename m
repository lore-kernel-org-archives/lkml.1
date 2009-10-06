Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbZJFTZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbZJFTZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933039AbZJFTZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:25:18 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:53140 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015AbZJFTZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:25:17 -0400
Date: Tue, 6 Oct 2009 12:22:43 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091006192242.GC7010@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
	Len Brown <lenb@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu>
 <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain>
 <20091006153632.GA29795@elte.hu>
 <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
 <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4ACB9910.01AD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 09:31:03AM -0700, Linus Torvalds wrote:
> On Tue, 6 Oct 2009, Linus Torvalds wrote:
> > 
> > Unless:
> > 
> > > _That_ i think is a lot harder to confuse with the real .31 than a 
> > > v2.6.31-1234-g16123c4 version string.
> > 
> > .. are you saying that it would be just some automatically generated 
> > thing, just a crippled form of CONFIG_LOCALVERSION_AUTO? Kind of a 
> > CONFIG_LOCALVERSION_AUTO_SHORTFORM?
> 
> So how about this?
> 
> It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial 
> way:
> 
>  - if it is set, things work the way they always have, and you get a 
>    extended kernel release like
> 
> 	2.6.32-rc3-00052-g0eca52a-dirty
> 
>  - but if it is _not_ set, we'll still try to get a version from the 
>    underlying SCM (we actually support git, hg and SVN right now, even if 
>    some comments may say "git only"), and if the underlying SCM says it 
>    has a local version, we append just "+", so you get a version number 
>    like
> 
> 	2.6.32-rc3+

	I really like this, because I don't want to see
LOCALVERSION_AUTO forced on.  While I like LOCALVERSION_AUTO in theory,
in practice it means that a one-line commit forces me to install an
entirely new /lib/modules directory.  On many of my test machines this
fills up quickly.  So I turn of LOCALVERSION_AUTO and just set a manual
LOCALVERSION.

Joel

-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

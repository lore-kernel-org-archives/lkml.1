Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZAOBze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZAOBze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 20:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZAOBzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 20:55:24 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:59180 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZAOBzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 20:55:23 -0500
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
From: Chris Mason <chris.mason@oracle.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, wk <handygewinnspiel@gmx.de>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl, HWerner4@gmx.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mchehab@infradead.org
In-Reply-To: <ac3eb2510901141500w5950c61dyba8af2e1d515ee08@mail.gmail.com>
References: <20090112190420.51f75853@pedra.chehab.org>
	 <20090113105947.9e774b69.akpm@linux-foundation.org>
	 <20090113191757.74290@gmx.net>
	 <20090113113700.776a94b5.akpm@linux-foundation.org>
	 <20090113203843.GJ29283@parisc-linux.org>
	 <1231957750.8269.28.camel@think.oraclecorp.com> <496E56EB.2030301@gmx.de>
	 <1231968240.8269.48.camel@think.oraclecorp.com>
	 <496E5AB2.7040507@sandeen.net>
	 <1231969221.8269.50.camel@think.oraclecorp.com>
	 <ac3eb2510901141500w5950c61dyba8af2e1d515ee08@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 20:54:38 -0500
Message-Id: <1231984478.8269.57.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.496E9763.003C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 00:00 +0100, Kay Sievers wrote:
> On Wed, Jan 14, 2009 at 22:40, Chris Mason <chris.mason@oracle.com> wrote:
> > On Wed, 2009-01-14 at 15:35 -0600, Eric Sandeen wrote:
> >
> >> >> Attached the log from stracing the command which was ivoked by the
> >> >> Makefile from v4l-dvb.
> >> >> I guess this is all i could contribute to that problem. Thats stuff for
> >> >> xfs filesystem experts now..
> >> >
> >> > Seems suspect indeed.  Could you please attach the strace for the run
> >> > that works on the older kernel?
> >>
> >> Chris got my attention on this one; you probably want this fix from hch:
> >>
> >> http://oss.sgi.com/archives/xfs/2009-01/msg00158.html
> >
> > Seems like this one should get queued for -stable as well if it isn't
> > already.
> 
> Chris, is this similar to the thing we've seen with btrfs? Is this fixed?

Similar yes, although I can't blame my bug on David Woodhouse.  Not
fixed yet, but I'll jump on it this week.

-chris



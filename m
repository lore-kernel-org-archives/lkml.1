Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbYD3Hqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbYD3Hqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbYD3Hqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:46:38 -0400
Received: from www.tglx.de ([62.245.132.106]:45977 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438AbYD3Hqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:46:38 -0400
Date: Wed, 30 Apr 2008 09:46:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
In-Reply-To: <20080430064603.GA3602@atjola.homenet>
Message-ID: <alpine.LFD.1.10.0804300945150.6003@apollo.tec.linutronix.de>
References: <1209268817.14173.43.camel@brick> <20080427042051.GL5882@ZenIV.linux.org.uk> <20080429210435.GA23008@elte.hu> <20080430064603.GA3602@atjola.homenet>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-85947036-1209541575=:6003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-85947036-1209541575=:6003
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 30 Apr 2008, Björn Steinbrink wrote:
> On 2008.04.29 23:04:35 +0200, Ingo Molnar wrote:
> > 
> > * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > On Sat, Apr 26, 2008 at 09:00:17PM -0700, Harvey Harrison wrote:
> > > > As written, this can never be true.
> > > 
> > > ... and introduced through x86.git, of all things...  May I suggest 
> > > that in addition to all-important whitespace hunting something that 
> > > catches lowly real bugs would also be run over that tree?  sparse 
> > > *does* catch that...
> > 
> > firstly, it _was_ caught via Sparse, ...
> 
> But that is exactly Al's point. Had you run sparse over your tree
> _before_ it got pulled by Linus, that bug should have never made it into
> mainline.

sparse builds are on the way to the automated build framework
already. won't happen again.

Thanks,
	tglx
--8323328-85947036-1209541575=:6003--

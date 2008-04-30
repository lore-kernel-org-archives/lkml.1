Return-Path: <linux-kernel-owner+w=401wt.eu-S1761172AbYD3GqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172AbYD3GqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbYD3GqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:46:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:49743 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755135AbYD3GqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:46:07 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/xeDZ+e8rx5JODpnQElPmNKVo/y/qmG7ClSNjmFT
	25V0nWfsJbdGR6
Date: Wed, 30 Apr 2008 08:46:03 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
Message-ID: <20080430064603.GA3602@atjola.homenet>
References: <1209268817.14173.43.camel@brick> <20080427042051.GL5882@ZenIV.linux.org.uk> <20080429210435.GA23008@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080429210435.GA23008@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.04.29 23:04:35 +0200, Ingo Molnar wrote:
> 
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Sat, Apr 26, 2008 at 09:00:17PM -0700, Harvey Harrison wrote:
> > > As written, this can never be true.
> > 
> > ... and introduced through x86.git, of all things...  May I suggest 
> > that in addition to all-important whitespace hunting something that 
> > catches lowly real bugs would also be run over that tree?  sparse 
> > *does* catch that...
> 
> firstly, it _was_ caught via Sparse, ...

But that is exactly Al's point. Had you run sparse over your tree
_before_ it got pulled by Linus, that bug should have never made it into
mainline.

Björn

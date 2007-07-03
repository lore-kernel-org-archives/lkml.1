Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbXGCWKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbXGCWKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbXGCWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:10:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:39659 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752509AbXGCWKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:10:03 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+/m99XLEm/M10G7wrYdHok0xMMiQas6zzsD1nnlv
	erukYrgHurtQjh
Date: Wed, 4 Jul 2007 00:12:10 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: 2.6.22-rc7: known regressions with patches
Message-ID: <20070703221210.GA29959@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
	Stephane Eranian <eranian@hpl.hp.com>
References: <468A7D24.3040004@googlemail.com> <20070703213614.GA29175@atjola.homenet> <alpine.LFD.0.98.0707031441480.9434@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.98.0707031441480.9434@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.07.03 14:42:25 -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 3 Jul 2007, Bj?rn Steinbrink wrote:
> > Andi said that one of the regression fixes wasn't critical for .22 and
> > that he wants to do a stopgap for the other regression (my patch
> > sucked), reverting the code to the .21 version. So you can drop the
> > patches and/or me here.
> 
> Can you say which patch should be reverted. This thing really shouldn't 
> have gone on this long, I would have hopef we had the oprofile thing 
> sorted out already..

That would be commit 09198e68501a7e34737cd9264d266f42429abcdc, for which
there are already a few fixes in your tree. Andi, did you intent to
fully revert that, or just certain parts of it?

Björn

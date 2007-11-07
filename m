Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbXKGGrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbXKGGrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbXKGGqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:46:52 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:51088 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755194AbXKGGqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:46:51 -0500
Message-ID: <394418014.24002@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 7 Nov 2007 14:46:47 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David <david@unsolicited.net>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc1 - Regularly getting processes stuck in D state on
	startup
References: <472F5F8B.7090200@unsolicited.net> <E1IpJLy-0002ag-TL@localhost> <394337271.18157@ustc.edu.cn> <20071107141717.6eb0dc25.sfr@canb.auug.org.au> <20071107142609.071532ad.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107142609.071532ad.sfr@canb.auug.org.au>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1IpegZ-0001aK-OJ@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 02:26:09PM +1100, Stephen Rothwell wrote:
> On Wed, 7 Nov 2007 14:17:17 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Tue, Nov 06, 2007 at 04:00:06PM +0800, Fengguang Wu wrote:
> > > 
> > > Could you try with the attached 4 patches? Two of them are expected to
> > > fix your problem, another two are debugging ones(in case the problem
> > > persists).
> > 
> > Applying these four patches fixes it for me.  Obviously the reiserfs patch
> > was not relevant in  my case (only using ext3).
> 
> I am now running on a kernel with just the
> mm-speed-up-writeback-ramp-up-on-clean-systems.patch applied and I am
> seeing no hangs.

Thank you(including David:-)) for the confirmation.

Andrew: so mm-speed-up-writeback-ramp-up-on-clean-systems.patch is a
safe and working patch ;-)

Fengguang


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZL2B0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZL2B0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 20:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZL2B0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 20:26:06 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50480 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZL2B0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 20:26:05 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5845"; a="31037544"
Subject: Re: tree with htc dream support
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <20091228204848.GB1637@ucw.cz>
References: <20091213212504.GD5114@elf.ucw.cz>
	 <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com>
	 <20091227093537.GD11737@elf.ucw.cz> <20091227201514.GA29174@elf.ucw.cz>
	 <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com>
	 <20091227203704.GK11737@elf.ucw.cz> <20091227211322.GB29174@elf.ucw.cz>
	 <a55d774e0912271646m1b82687cy427083e64e91e323@mail.gmail.com>
	 <20091227101824.GB1478@ucw.cz>
	 <a55d774e0912281224y7360dfdbu8a251743026bdd28@mail.gmail.com>
	 <20091228204848.GB1637@ucw.cz>
Content-Type: text/plain
Date: Mon, 28 Dec 2009 17:25:13 -0800
Message-Id: <1262049913.17445.27.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 21:48 +0100, Pavel Machek wrote:
> Hi!
> 
> > >> > Switch smd code to the version in staging. Something to apply to
> > >> > dream/ tree I'd say... and yes, it still works.
> > >>
> > >> I think we might want to consider leaving at least the core smd code
> > >> under mach-msm.
> > >
> > > In the long run, I agree.
> > >
> > > In the short run... the code is staging quality, so it should be in
> > > staging... and you'll not have to mainain so huge diff. (-20 kLoc).
> > 
> > The core smd stuff is really not that large.  The central smd.[ch] are
> > about 1300 lines, and proc_comm.[ch] are about 400 lines.  Is it
> > possible to get some review/feedback as to what's "staging quality"
> > about this code so we can clean it up?  I'd rather just fix the
> > issues
> 
> Just submit it to Daniel W., ccing rmk and l-a-k, and I'm sure you'll
> get feedback.

I have it in my tree already .. My tree has some duplication over
staging, for instance the rpc code is mostly in my tree, as is the smd
code.

Daniel


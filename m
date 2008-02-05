Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbYBENid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbYBENid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 08:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYBENiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 08:38:22 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:55875 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbYBENiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:38:21 -0500
Date: Tue, 5 Feb 2008 22:38:02 +0900
To: mangoo@wpkg.org
Cc: James.Bottomley@HansenPartnership.com, bart.vanassche@gmail.com,
       vst@vlnb.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, scst-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <47A80CB9.9000805@wpkg.org>
References: <e2e108260801300029r1a949353k73b30f1f28db0bc9@mail.gmail.com>
	<1201710175.3292.16.camel@localhost.localdomain>
	<47A80CB9.9000805@wpkg.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080205223740L.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 08:14:01 +0100
Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> James Bottomley schrieb:
> 
> > These are both features being independently worked on, are they not?
> > Even if they weren't, the combination of the size of SCST in kernel plus
> > the problem of having to find a migration path for the current STGT
> > users still looks to me to involve the greater amount of work.
> 
> I don't want to be mean, but does anyone actually use STGT in
> production? Seriously?
> 
> In the latest development version of STGT, it's only possible to stop
> the tgtd target daemon using KILL / 9 signal - which also means all
> iSCSI initiator connections are corrupted when tgtd target daemon is
> started again (kernel upgrade, target daemon upgrade, server reboot etc.).

I don't know what "iSCSI initiator connections are corrupted"
mean. But if you reboot a server, how can an iSCSI target
implementation keep iSCSI tcp connections?


> Imagine you have to reboot all your NFS clients when you reboot your NFS
> server. Not only that - your data is probably corrupted, or at least the
> filesystem deserves checking...

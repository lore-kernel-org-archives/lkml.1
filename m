Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZDMVbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZDMVbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZDMVbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:31:10 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:53300 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbZDMVbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:31:09 -0400
To: paulmck@linux.vnet.ibm.com
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, hugh@veritas.com,
       jmorris@namei.org, akpm@linux-foundation.org
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp>
	<20090410231245.GF6719@linux.vnet.ibm.com>
	<20090410233919.GS26366@ZenIV.linux.org.uk>
	<200904130048.n3D0mw1f077050@www262.sakura.ne.jp>
	<20090413195504.GF6983@linux.vnet.ibm.com>
In-Reply-To: <20090413195504.GF6983@linux.vnet.ibm.com>
Message-Id: <200904140631.BCI82883.LFOHOFJtFMOSVQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 14 Apr 2009 06:31:05 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> > Hello.
> > 
> > Paul E. McKenney wrote:
> > > Is this reproducible?
> > Not always, but it is reproducible.
> 
> Does it reproduce well enough to bisect?
> 
Not impossible, but difficult. This happens less than once on 10 trials.

> > Al Viro wrote:
> > > I'd really love to see results of repeated alt-sysrq-p/alt-sysrq-l, just
> > > to see where was it actually spinning.
> > Below is sysrq message.
> > Maybe something related to khelper's current->mm == NULL warning problem.
> > Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc1-200904130930.txt .
> 
> I have to defer to the mm guys on this one.

Latest info on khelper's current->mm == NULL warning problem is at
http://lkml.org/lkml/2009/4/13/85 .

Thanks.

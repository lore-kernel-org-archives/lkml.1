Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZDMWrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZDMWrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZDMWr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:47:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58892 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbZDMWr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:47:26 -0400
Date: Mon, 13 Apr 2009 15:47:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, hugh@veritas.com,
       jmorris@namei.org, akpm@linux-foundation.org
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
Message-ID: <20090413224724.GJ6983@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp> <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk> <200904130048.n3D0mw1f077050@www262.sakura.ne.jp> <20090413195504.GF6983@linux.vnet.ibm.com> <200904140631.BCI82883.LFOHOFJtFMOSVQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904140631.BCI82883.LFOHOFJtFMOSVQ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 06:31:05AM +0900, Tetsuo Handa wrote:
> Paul E. McKenney wrote:
> > > Hello.
> > > 
> > > Paul E. McKenney wrote:
> > > > Is this reproducible?
> > > Not always, but it is reproducible.
> > 
> > Does it reproduce well enough to bisect?
> > 
> Not impossible, but difficult. This happens less than once on 10 trials.
> 
> > > Al Viro wrote:
> > > > I'd really love to see results of repeated alt-sysrq-p/alt-sysrq-l, just
> > > > to see where was it actually spinning.
> > > Below is sysrq message.
> > > Maybe something related to khelper's current->mm == NULL warning problem.
> > > Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc1-200904130930.txt .
> > 
> > I have to defer to the mm guys on this one.
> 
> Latest info on khelper's current->mm == NULL warning problem is at
> http://lkml.org/lkml/2009/4/13/85 .

Thank you for the pointer!

							Thanx, Paul

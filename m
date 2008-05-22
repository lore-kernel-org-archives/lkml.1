Return-Path: <linux-kernel-owner+w=401wt.eu-S1762479AbYEVWwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479AbYEVWwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYEVWwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:52:11 -0400
Received: from iron2.pdx.net ([69.64.224.71]:60199 "EHLO iron2.pdx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbYEVWwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:52:10 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 May 2008 18:52:10 EDT
Subject: Re: [PATCH] firewire: fix some broken hardware NMI interrupt
From: Sean Bruno <sean.bruno@dsl-only.net>
To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc: stefanr@s5r6.in-berlin.de, krh@redhat.com,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <411458028.04591@ustc.edu.cn>
References: <411458028.04591@ustc.edu.cn>
Content-Type: text/plain
Date: Thu, 22 May 2008 15:45:24 -0700
Message-Id: <1211496325.1374.99.camel@home-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 20:07 +0800, JiSheng Zhang wrote:
> Hi,
> 
> 
> >From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> >Reply-To: 
> >To: jszhang3@mail.ustc.edu.cn
> >Subject: Re: [PATCH] firewire: fix some broken hardware NMI interrupt
> >Date:Wed, 21 May 2008 17:28:25 +0200
> >
> >jszhang3@mail.ustc.edu.cn wrote:
> > > Some broken pci-1394 card does not clear completely on-chip memory during
> boot, it
> > > may cause pci parity error, then NMI interrupt.
> > 
> > Which card?
> hmm, one card using VIA chip.
> > 
> > Is the problem still present in linux-2.6.26-rc3?
> It seems that the problem disappeared. Thanks
> > 
> > Or if you don't want to test 2.6.26-rc yet, please test 2.6.25.4 with
> > the firewire patchkit from
> > http://me.in-berlin.de/~s5r6/linux1394/updates/.  There were changes to
> > fw-ohci which influence chip initialization.
> > -- 
> > Stefan Richter
> > -=====-==--- -=-= =-=-=
> > http://arcgraph.de/sr/
> >
> 
> 
I've got a VIA board causing the same error reported here.

If someone at Redhat has the time to roll a test kernel for this issue I
can test it in about 15 minutes.

Right now I'm running RHEL 5, 2.6.18-53.1.21.el5

Se


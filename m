Return-Path: <linux-kernel-owner+w=401wt.eu-S941661AbXGaCqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941661AbXGaCqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763849AbXGaCqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:46:39 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:40014 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761038AbXGaCqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:46:38 -0400
X-IronPort-AV: i="4.19,201,1183348800"; 
   d="scan'208"; a="46946305:sNHT26639431"
Subject: Re: [PATCH] Remove fs.h from mm.h
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: Bryan Wu <bryan.wu@analog.com>
In-Reply-To: <20070730194335.GE5776@martell.zuzino.mipt.ru>
References: <20070729223613.GA5916@martell.zuzino.mipt.ru>
	 <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org>
	 <1185770527.22473.2.camel@roc-desktop>
	 <20070730194335.GE5776@martell.zuzino.mipt.ru>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 31 Jul 2007 10:51:37 +0800
Message-Id: <1185850297.20043.6.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 31 Jul 2007 02:46:36.0378 (UTC) FILETIME=[03277BA0:01C7D31D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 23:43 +0400, Alexey Dobriyan wrote:
> On Mon, Jul 30, 2007 at 12:42:07PM +0800, Bryan Wu wrote:
> > Can I do something to help this regression testing?
> >
> > Please feel free to ask me.
> 
> Sorry, blackfin toolchain doesn't like me, so I can't test this myself.
> Check current -git if I screwed up anything.
> 
Oh, do you need use blackfin toolchain? Actually, it is very simple to
setup it on your machine.
please get the latest binary toolchain here:
http://blackfin.uclinux.org/gf/download/frsrelease/344/3180/blackfin-toolchain-uclinux-SVN.tar.bz2
http://blackfin.uclinux.org/gf/download/frsrelease/344/3181/blackfin-toolchain-linux-uclibc-SVN.tar.bz2

 - untar these 2 tar ball
 - add the path to your environment variables
 - ready to compile the kernel by these blackfin cross toolchain

> It still takes too much time from clean git pull to final patch, so
> sending it to you would  increase risk that someone will touch core
> headers nontrivially invalidating all work.

Need I to generate the patch? I will take a look at the latest git-tree.

Many thanks, we hope you can add our blackfin to your cross-build check.

Best Regards,
- Bryan Wu

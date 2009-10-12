Return-Path: <linux-kernel-owner+w=401wt.eu-S1758425AbZJLVbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425AbZJLVbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbZJLVbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:31:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36220 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbZJLVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:31:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #14261] e1000e jumbo frames no longer work: 'Unsupported MTU setting'
Date: Mon, 12 Oct 2009 23:32:29 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       alexander.duyck@gmail.com, nix@esperi.org.uk
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.C2C.pzl0KB@chimera> <20091011.201239.06501504.davem@davemloft.net>
In-Reply-To: <20091011.201239.06501504.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910122332.29994.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Mon, 12 Oct 2009 01:01:08 +0200 (CEST)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14261
> > Subject		: e1000e jumbo frames no longer work: 'Unsupported MTU setting'
> > Submitter	: Nix <nix@esperi.org.uk>
> > Date		: 2009-09-26 11:16 (16 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125396433321342&w=4
> > Handled-By	: Alexander Duyck <alexander.duyck@gmail.com>
> > Patch		: http://patchwork.kernel.org/patch/50277/
> 
> Fixed by:
> 
> commit a825e00c98a2ee37eb2a0ad93b352e79d2bc1593
> Author: Alexander Duyck <alexander.h.duyck@intel.com>
> Date:   Fri Oct 2 12:30:42 2009 +0000
> 
>     e1000e: swap max hw supported frame size between 82574 and 82583
>     
>     There appears to have been a mixup in the max supported jumbo frame size
>     between 82574 and 82583 which ended up disabling jumbo frames on the 82574
>     as a result.  This patch swaps the two so that this issue is resolved.
>     
>     This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=14261
>     
>     Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>     Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks, closing.

Rafael

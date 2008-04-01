Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYDADRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYDADRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 23:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYDADRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 23:17:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58971
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbYDADRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 23:17:02 -0400
Date: Mon, 31 Mar 2008 20:17:02 -0700 (PDT)
Message-Id: <20080331.201702.119420148.davem@davemloft.net>
To: rpjday@crashcourse.ca
Cc: bunk@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] forgotten bits of Sangoma drivers removal
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0803312313210.21490@localhost.localdomain>
References: <20080330224901.GW28445@cs181133002.pp.htv.fi>
	<20080331.193329.195976331.davem@davemloft.net>
	<alpine.LFD.1.00.0803312313210.21490@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Date: Mon, 31 Mar 2008 23:14:46 -0400 (EDT)

> On Mon, 31 Mar 2008, David Miller wrote:
> 
> > From: Adrian Bunk <bunk@kernel.org>
> > Date: Mon, 31 Mar 2008 01:49:01 +0300
> >
> > > Robert P. J. Day spotted that my removal of the Sangoma drivers missed a
> > > few bits.
> > >
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > I must have missed some context or another patch, but
> > linux/if_wanpipe.h is still there, so I can't see why
> > we can remove it from linux/Kbuild
> 
> AFAICT, nothing in the source tree includes that header file, so i'm
> guessing that the patch should also include simply deleting it if it
> has no further value.

Ok, that makes sense.

Adrian, if you agree, please respin your patch with that
modification.

Thanks.

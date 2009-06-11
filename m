Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZFKMoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZFKMoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZFKMoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:44:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49855
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbZFKMoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:44:38 -0400
Date: Thu, 11 Jun 2009 05:44:41 -0700 (PDT)
Message-Id: <20090611.054441.84283528.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: kaber@trash.net, fubar@us.ibm.com, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding: fix multiple module load problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090609230754.77fb1e71@nehalam>
References: <4752.1244564082@death.nxdomain.ibm.com>
	<4A2E8D62.6090004@trash.net>
	<20090609230754.77fb1e71@nehalam>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 9 Jun 2009 23:07:54 -0700

> Some users still load bond module multiple times to create bonding
> devices.  This accidentally was broken by a later patch about
> the time sysfs was fixed.  According to Jay, it was broken
> by:
>    commit b8a9787eddb0e4665f31dd1d64584732b2b5d051
>    Author: Jay Vosburgh <fubar@us.ibm.com>
>    Date:   Fri Jun 13 18:12:04 2008 -0700
> 
>      bonding: Allow setting max_bonds to zero
> 
> Note: sysfs and procfs still produce WARN() messages when this is done
> so the sysfs method is the recommended API.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied, and queued up for -stable, thanks!

Return-Path: <linux-kernel-owner+w=401wt.eu-S965153AbXCVTL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153AbXCVTL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbXCVTL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:11:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35913
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965238AbXCVTL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:11:26 -0400
Date: Thu, 22 Mar 2007 12:11:26 -0700 (PDT)
Message-Id: <20070322.121126.112613159.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: w@1wt.eu, rkuhn@e18.physik.tu-muenchen.de, andi@firstfloor.org,
       dada1@cosmosbay.com, jengelh@linux01.gwdg.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] div64_64 optimization
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070321131532.66e7f0e1@freekitty>
References: <20070321115419.483a655a@freekitty>
	<20070321191537.GA28914@1wt.eu>
	<20070321131532.66e7f0e1@freekitty>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 21 Mar 2007 13:15:32 -0700

> Minor optimization of div64_64.  do_div() already does optimization
> for the case of 32 by 32 divide, so no need to do it here.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

Applied to net-2.6.22

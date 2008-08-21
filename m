Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbYHUVFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbYHUVFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYHUVFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:05:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49767
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755511AbYHUVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:05:03 -0400
Date: Thu, 21 Aug 2008 14:05:02 -0700 (PDT)
Message-Id: <20080821.140502.146697690.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] math-emu: Add support for reporting exact invalid
 exception
From: David Miller <davem@davemloft.net>
In-Reply-To: <1219323021-7273-2-git-send-email-galak@kernel.crashing.org>
References: <1219323021-7273-1-git-send-email-galak@kernel.crashing.org>
	<1219323021-7273-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Thu, 21 Aug 2008 07:50:21 -0500

> Some architectures (like powerpc) provide status information on the exact
> type of invalid exception.  This is pretty straight forward as we already
> report invalid exceptions via FP_SET_EXCEPTION.
> 
> We add new flags (FP_EX_INVALID_*) the architecture code can define if it
> wants the exact invalid exception reported.
> 
> We had to split out the INF/INF and 0/0 cases for divide to allow reporting
> the two invalid forms properly.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

Acked-by: David S. Miller <davem@davemloft.net>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYADWbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYADWbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbYADWbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:31:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38646
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755256AbYADWbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:31:20 -0500
Date: Fri, 04 Jan 2008 14:31:12 -0800 (PST)
Message-Id: <20080104.143112.93580751.davem@davemloft.net>
To: rdreier@cisco.com
Cc: mboton.lkml@gmail.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       linville@tuxdriver.com
Subject: Re: [PATCH] iwlwifi: fix compilation warning in 'iwl-4965.c'
From: David Miller <davem@davemloft.net>
In-Reply-To: <adaabnlme87.fsf@cisco.com>
References: <200801042305.55188.mboton@gmail.com>
	<adaabnlme87.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 04 Jan 2008 14:13:12 -0800

>  > -			       "radiotap head [%d]\n",
>  > +			       "radiotap head [%ld]\n",
>  >  			       skb_headroom(skb), sizeof(*iwl4965_rt));
> 
> Actually I think the correct printf format for printing a size_t
> (coming here from sizeof foo) is "%zd".  Otherwise you'll fix the
> warning on 64-bit targets but add a new warning on 32-bit targets.

Right.

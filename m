Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbXLPWWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbXLPWWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 17:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbXLPWV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 17:21:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35425
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757530AbXLPWV6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 17:21:58 -0500
Date: Sun, 16 Dec 2007 14:21:52 -0800 (PST)
Message-Id: <20071216.142152.187297327.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: akpm@linux-foundation.org, clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, reuben-linuxkernel@reub.net,
       kamalesh@linux.vnet.ibm.com, riel@redhat.com, dhaval@linux.vnet.ibm.com
Subject: Re: [PATCH net-2.6.25] Revert recent TCP work
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0712141946060.1400@kivilampi-30.cs.helsinki.fi>
References: <47616FA6.1010607@fr.ibm.com>
	<Pine.LNX.4.64.0712140024360.12376@kivilampi-30.cs.helsinki.fi>
	<Pine.LNX.4.64.0712141946060.1400@kivilampi-30.cs.helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Fri, 14 Dec 2007 22:14:29 +0200 (EET)

> Could you either drop my recent patches (+one fix to them from Herbert
> Xu == "[TCP]: Fix crash in tcp_advance_send_head"), all mine after "[TCP]: 
> Abstract tp->highest_sack accessing & point to next skb" from net-2.6.25 
> or just apply the revert from below and do the removal during next rebase. 
> I think it could even be automated by something like this (untested):
> for i in $(cat commits | cut -d ' ' -f 1); do git-rebase --onto $i^ $i; done 
> (I've attached the commits list).

I'll take care of this when I rebase the net-2.6.25 tree later
today.

Thanks Ilpo.

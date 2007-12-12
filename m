Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbXLLPW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbXLLPW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbXLLPWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:22:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45170
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbXLLPWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:22:13 -0500
Date: Wed, 12 Dec 2007 07:22:12 -0800 (PST)
Message-Id: <20071212.072212.106556355.davem@davemloft.net>
To: joonwpark81@gmail.com
Cc: shemminger@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       baum@tehutinetworks.net, andy@greyhouse.net
Subject: Re: [RFC] net: napi fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <b25c3fa70712112205l2e778bacx66470606272b199@mail.gmail.com>
References: <20071211213939.122de1db@freepuppy.rosehill>
	<20071211214634.4dedb274@freepuppy.rosehill>
	<b25c3fa70712112205l2e778bacx66470606272b199@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joonwoo Park" <joonwpark81@gmail.com>
Date: Wed, 12 Dec 2007 15:05:26 +0900

> Could you explain how it fix the problem?
> IMHO I think your patch cannot solve the problem.
> The drivers can call netif_rx_complete and net_rx_action can do
> list_move_tail also.

Stephen is confused about what the bug is in these drivers,
that's all.

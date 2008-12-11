Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYLKBZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYLKBZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbYLKBYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:24:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55288
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbYLKBYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:24:53 -0500
Date: Wed, 10 Dec 2008 17:24:54 -0800 (PST)
Message-Id: <20081210.172454.178901962.davem@davemloft.net>
To: eric@inl.fr
Cc: kamalesh@linux.vnet.ibm.com, randy.dunlap@oracle.com, sfr@canb.auug.org.au,
       netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       kaber@trash.net
Subject: Re: netfilter: xt_NFLOG is dependant of nfnetlink_log
From: David Miller <davem@davemloft.net>
In-Reply-To: <1228934957-11967-1-git-send-email-eric@inl.fr>
References: <1228934630.5961.8.camel@ice-age>
	<1228934957-11967-1-git-send-email-eric@inl.fr>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Leblond <eric@inl.fr>
Date: Wed, 10 Dec 2008 19:49:17 +0100

> The patch "don't call nf_log_packet in NFLOG module" make xt_NFLOG
> dependant of nfnetlink_log. This patch forces the dependencies to fix
> compilation in case only xt_NFLOG compilation was asked and modifies the
> help message accordingly to the change.
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>

I've applied this to net-next-2.6, thanks Eric.

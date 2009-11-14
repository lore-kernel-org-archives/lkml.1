Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbZKNDwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbZKNDwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 22:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbZKNDwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:52:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36725
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756626AbZKNDwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:52:14 -0500
Date: Fri, 13 Nov 2009 19:52:30 -0800 (PST)
Message-Id: <20091113.195230.02147359.davem@davemloft.net>
To: stas@lvk.cs.msu.su
Cc: aabdulla@nvidia.com, yinghai@kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] forcedeth: mac address fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1258114975-5715-1-git-send-email-stas@lvk.cs.msu.su>
References: <1258114975-5715-1-git-send-email-stas@lvk.cs.msu.su>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Stanislav O\. Bezzubtsev" <stas@lvk.cs.msu.su>
Date: Fri, 13 Nov 2009 15:22:55 +0300

> Set second bit of randomly generated mac. That marks MAC
> as locally assigned. IEEE802.3, section one, 3.2.3.
> 
> Signed-off-by: Stanislav O. Bezzubtsev <stas@lvk.cs.msu.su>

Do you know why this driver even has this bug?

It's because it does not use random_ether_addr() and tries to
do it by hand all by itself.

Please fix this bug for real by having the driver use the proper
interface to calculate a randomized ethernet address.

Thank you.

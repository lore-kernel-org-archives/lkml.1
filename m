Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbYLAVSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbYLAVSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYLAVSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:18:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45807
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbYLAVSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:18:10 -0500
Date: Mon, 01 Dec 2008 13:18:10 -0800 (PST)
Message-Id: <20081201.131810.158631503.davem@davemloft.net>
To: gallatin@myri.com
Cc: ossthema@de.ibm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       tklein@de.ibm.com, raisch@de.ibm.com, jb.billaud@gmail.com,
       hering2@de.ibm.com
Subject: Re: [PATCH] lro: IP fragment checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <493423D7.5030203@myri.com>
References: <4933A74F.3050809@de.ibm.com>
	<493423D7.5030203@myri.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Gallatin <gallatin@myri.com>
Date: Mon, 01 Dec 2008 12:50:15 -0500

> As to whether or not to do it in the drivers/hardware or in the
> LRO code, I favor doing it in the LRO code just so that it is not
> missed in some driver.

Then there is no point in the hardware doing the check, if
we're going to check it anyways.

That's part of my point about why this check doesn't belong
here.

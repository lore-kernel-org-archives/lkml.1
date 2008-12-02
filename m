Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYLBAHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYLBAHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 19:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYLBAH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 19:07:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55273
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbYLBAHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 19:07:25 -0500
Date: Mon, 01 Dec 2008 16:07:22 -0800 (PST)
Message-Id: <20081201.160722.114600830.davem@davemloft.net>
To: gallatin@myri.com
Cc: ossthema@de.ibm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       tklein@de.ibm.com, raisch@de.ibm.com, jb.billaud@gmail.com,
       hering2@de.ibm.com
Subject: Re: [PATCH] lro: IP fragment checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <49345CCA.1030209@myri.com>
References: <493423D7.5030203@myri.com>
	<20081201.131810.158631503.davem@davemloft.net>
	<49345CCA.1030209@myri.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Gallatin <gallatin@myri.com>
Date: Mon, 01 Dec 2008 16:53:14 -0500

> What hardware does an explicit check for fragmentation?

If the packet is fragmented, the chip shouldn't even be
looking at the ports to make LRO deferral decisions let
alone pass it down as a LRO'able frame.

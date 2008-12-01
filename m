Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbYLAJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbYLAJlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 04:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYLAJlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 04:41:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46912
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYLAJlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 04:41:01 -0500
Date: Mon, 01 Dec 2008 01:41:01 -0800 (PST)
Message-Id: <20081201.014101.33453764.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, tklein@de.ibm.com,
       raisch@de.ibm.com, jb.billaud@gmail.com, hering2@de.ibm.com
Subject: Re: [PATCH] lro: IP fragment checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <4933A74F.3050809@de.ibm.com>
References: <4933A74F.3050809@de.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Mon, 01 Dec 2008 09:58:55 +0100

> This patch prevents that ip fragmented TCP packets are considered vaild
> for aggregation

We discussed this last week.

The things feeding packets into the LRO machinery should make this
check, and that could be a hardware LRO assist.

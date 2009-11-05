Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZKEHwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZKEHwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 02:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZKEHwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 02:52:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59889
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbZKEHwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 02:52:50 -0500
Date: Wed, 04 Nov 2009 23:53:15 -0800 (PST)
Message-Id: <20091104.235315.18303666.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       kristoffer@gaisler.com
Subject: Re: linux-next: sparc tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091105185014.76dd0d31.sfr@canb.auug.org.au>
References: <20091105185014.76dd0d31.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 5 Nov 2009 18:50:14 +1100

> Caused by commit d4ac42a582e46d7f86f0acb4253a310423c72c4c ("sparc:
> Support for GRLIB APBUART serial port").  I added the following patch for
> today.

Thanks, the real fix is to simply remove that include, it isn't
actually needed and the CONFIG_OF dependency is sufficient.

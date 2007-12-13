Return-Path: <linux-kernel-owner+w=401wt.eu-S934170AbXLMWdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170AbXLMWdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932702AbXLMWct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:32:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50638
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932421AbXLMWcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:32:48 -0500
Date: Thu, 13 Dec 2007 14:32:46 -0800 (PST)
Message-Id: <20071213.143246.175833292.davem@davemloft.net>
To: bunk@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071213222044.GH21616@stusta.de>
References: <20071213222044.GH21616@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Thu, 13 Dec 2007 23:20:44 +0100

> My question is:
> Is there anywhere in the kernel a case where __read_mostly brings a 
> measurable improvement or can it be removed?

Yes, on SMP when read-mostly objects share cache lines
with other objects which are frequently written to.

That is the whole reason we created __read_mostly

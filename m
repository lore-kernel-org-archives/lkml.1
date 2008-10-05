Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYJEWbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYJEWbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbYJEWbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:31:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52119
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbYJEWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:31:24 -0400
Date: Sun, 05 Oct 2008 15:30:59 -0700 (PDT)
Message-Id: <20081005.153059.111120997.davem@davemloft.net>
To: swivel@shells.gnugeneration.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081005214556.GL18569@fc6222126.aspadmin.net>
References: <20080921220926.GA18569@fc6222126.aspadmin.net>
	<20081005.132722.203253085.davem@davemloft.net>
	<20081005214556.GL18569@fc6222126.aspadmin.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: swivel@shells.gnugeneration.com
Date: Sun, 5 Oct 2008 16:45:57 -0500

> I will be testing this patch today.  At a glance it appears with this
> patch we're still not taking rcvlowat into consideration in recv()
> with MSG_PEEK flag set.  This should probably also be corrected, as
> mentioned in the thread previously.

Yes, I remember you mentioning that.

I'll look into it.

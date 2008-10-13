Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYJMKNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYJMKNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764903AbYJMJ6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:58:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47824
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761060AbYJMJ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:58:39 -0400
Date: Mon, 13 Oct 2008 02:58:16 -0700 (PDT)
Message-Id: <20081013.025816.197282812.davem@davemloft.net>
To: swivel@shells.gnugeneration.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081013083214.GN2811@fc6222126.aspadmin.net>
References: <20081005.153059.111120997.davem@davemloft.net>
	<20081013.003441.109866647.davem@davemloft.net>
	<20081013083214.GN2811@fc6222126.aspadmin.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: swivel@shells.gnugeneration.com
Date: Mon, 13 Oct 2008 03:32:14 -0500

> I'm using the pseudo-blocking recv() behavior achieved with SO_RCVTIMEO.
> Thus my app expects recv() to block until SO_RCVLOWAT is met or SO_RCVTIMEO
> expired.

But if you poll() properly, you'll never call recv() unless the amount
of bytes you want are there.

And since I fixed poll()'s handling of SO_RCVLOWAT it should mostly
work.

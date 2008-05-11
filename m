Return-Path: <linux-kernel-owner+w=401wt.eu-S1751619AbYEKEes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbYEKEes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 00:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750710AbYEKEei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 00:34:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41315
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbYEKEeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 00:34:37 -0400
Date: Sat, 10 May 2008 21:34:31 -0700 (PDT)
Message-Id: <20080510.213431.193696750.davem@davemloft.net>
To: jesper@krogh.cc
Cc: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
From: David Miller <davem@davemloft.net>
In-Reply-To: <48258074.7060306@krogh.cc>
References: <20080507.141521.193714938.davem@davemloft.net>
	<482498D5.9060008@krogh.cc>
	<48258074.7060306@krogh.cc>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Krogh <jesper@krogh.cc>
Date: Sat, 10 May 2008 13:01:08 +0200

> Any good suggestions about the "Transmit timed out" messages. It
> currently leads to a system that "doesnt die" but doesnt respond within
> 15 minutes of load of the network adapter.

It's likely some bug in the driver that hangs the card for whatever
reason, which we'll need to work out.

> Does the high amount of Context-switches (120.000+ have any influence)?

Unlikely.

> Should I be able to use TSO?

NIU doesn't support TSO.

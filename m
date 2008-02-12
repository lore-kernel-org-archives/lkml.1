Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbYBLGLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbYBLGLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761061AbYBLGK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:10:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37197
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761015AbYBLGKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:10:55 -0500
Date: Mon, 11 Feb 2008 22:11:26 -0800 (PST)
Message-Id: <20080211.221126.230471463.davem@davemloft.net>
To: arjan@infradead.org
Cc: greg@kroah.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080211211751.3e265754@laptopd505.fenrus.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org>
	<20080212044314.GA4888@kroah.com>
	<20080211211751.3e265754@laptopd505.fenrus.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Mon, 11 Feb 2008 21:17:51 -0800

> this is why you need specific trees for just the API change

API trees don't work, just like other changes they will have
interdependencies on things like fixups, cleanups, etc.

This is why, with the networking, we've just tossed all of the network
driver stuff in there too.  I can rebase freely, remove changesets,
rework them, etc. and this causes a very low amount of pain for Jeff
Garzik and John Linville.

This may or not be a legitimate thing to do with other heavily
dependant subsystems.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbZDGAoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbZDGAoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZDGAnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:43:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46993
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757390AbZDGAnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:43:51 -0400
Date: Mon, 06 Apr 2009 17:43:40 -0700 (PDT)
Message-Id: <20090406.174340.253577345.davem@davemloft.net>
To: tilman@imap.cc
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, hjlipp@web.de
Subject: Re: [PATCH 2/3] gigaset: in file ops, check for device disconnect
 before anything else
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090404-patch-02.tilman@imap.cc>
References: <20090404-patch-00.tilman@imap.cc>
	<20090404-patch-02.tilman@imap.cc>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sun,  5 Apr 2009 18:39:33 +0200 (CEST)

> When the device is disconnected, the dev structure goes away, so
> trying to report another error via dev_printk is bound to oops.
> To avoid that, first check whether the device is still connected
> and return quietly if it isn't.
> 
> Impact: error handling
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Tested-by: Paul Bolle <pebolle@tiscali.nl>

Applied.

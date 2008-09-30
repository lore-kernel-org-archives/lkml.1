Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYI3KXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYI3KXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYI3KXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:23:37 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:33869 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbYI3KXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:23:37 -0400
Message-Id: <20080930102313.418263345@zoo.weinigel.se>
User-Agent: quilt/0.46-1
Date: Tue, 30 Sep 2008 12:23:13 +0200
From: Christer Weinigel <christer@weinigel.se>
To: drzeus-list@drzeus.cx
Cc: Christer Weinigel <christer.weinigel@csr.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 0/3] RFC: Low-latency SDIO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre and anyone else who is interested,

Here is a cleaned up patch that implements the low-latency SDIO stuff
I mailed about a couple of weeks ago.  Basically the patches adds
asynchronous SDIO operations and makes it possible to register a
"hard" SDIO interrupt handler which will be called directly from
interrupt context (mmc_signal_sdio_irq).

So, tell me what you think. :-)

  /Christer

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se

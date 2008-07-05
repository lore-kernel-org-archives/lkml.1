Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbYGENow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbYGENow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 09:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYGENoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 09:44:44 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:36405 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbYGENon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 09:44:43 -0400
Date: Sat, 5 Jul 2008 15:44:36 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mmc: Export internal host state through debugfs
Message-ID: <20080705154436.27830440@siona.local>
In-Reply-To: <20080704194556.73061a08@mjolnir.drzeus.cx>
References: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214918094-26758-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214918094-26758-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20080704194556.73061a08@mjolnir.drzeus.cx>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jul 2008 13:44:38.0458 (UTC) FILETIME=[44C1C9A0:01C8DEA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008 19:45:56 +0200
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> I see that this version has no ifdef:s at all. Doesn't that mean a lot
> of useless code if DEBUG_FS is not enabled? You embedded guys are
> usually rather sensitive about such things. :)

Hmm...looks like gcc does a pretty poor job of eliminating unreachable
code, so we end up with about 1k of dead code in debugfs.o.

I guess we'll have to throw in a couple of #ifdefs then...

Haavard

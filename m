Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbZHNWY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbZHNWY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbZHNWYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:24:55 -0400
Received: from ru.mvista.com ([213.79.90.228]:26602 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750827AbZHNWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:24:54 -0400
Date: Sat, 15 Aug 2009 02:24:53 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] spi_mpc8xxx: Add support for DMA transfers
Message-ID: <20090814222453.GA9568@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are some patches that add DMA support for spi_mpc8xxx driver,
which means that we now support QE BD mode and SPI on CPM1 and CPM2
chips.

QE BD mode and CPM2 SPI support were tested on real hardware, CPM1
was only compile tested (though I belive it will work :-).

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

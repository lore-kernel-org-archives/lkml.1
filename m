Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659Ab0AYSKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0AYSKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182Ab0AYSKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:10:00 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:51269 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752674Ab0AYSKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:10:00 -0500
Date: Mon, 25 Jan 2010 21:09:57 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] OF GPIO integration for I2C/SPI GPIO chips
Message-ID: <20100125180957.GA5380@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Currently it's a burden to make I2C or SPI GPIO chips work with the
OF GPIO infrastructure. I've posted several approaches to solve the
issue before, and others have tried too. Here is another try.

This patch set is used to make things much easier, and completely
seamless for GPIO chips that don't need any platform data (e.g.
mcu_mpc8349emitx) or that have OF bindings already (e.g. pca953x).

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

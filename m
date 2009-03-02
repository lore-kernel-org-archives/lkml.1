Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZCBQ52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZCBQ52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZCBQ5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:57:18 -0500
Received: from mx1.emlix.com ([193.175.82.87]:52933 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZCBQ5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:57:17 -0500
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 17:42:57 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/7] xtensa fixes
Message-Id: <E1LeBS6-0003Yi-7J@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is fallout and preparation of the xtensa arch for the Stretch
S6000 core variant port.

The nommu stuff, the variant code and the platform code still need
some more beating in shape but will follow soon, along with the driver
proper for the peripherals we have on our evaluation board.

Please note that we have only this one nommu test setup and therefor
can only test one configuration.

	 Hannes

 arch/xtensa/Kconfig                   |  166 +++++++++++++++-----------------
 arch/xtensa/include/asm/mmu_context.h |    4 +-
 arch/xtensa/include/asm/page.h        |    5 +-
 arch/xtensa/kernel/traps.c            |   15 ++--
 arch/xtensa/mm/init.c                 |   16 ++--
 5 files changed, 100 insertions(+), 106 deletions(-)


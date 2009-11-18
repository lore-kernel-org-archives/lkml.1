Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbZKRLpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbZKRLpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 06:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZKRLpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 06:45:51 -0500
Received: from smtp.nokia.com ([192.100.105.134]:35187 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZKRLpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 06:45:50 -0500
Message-ID: <4B03DE53.6010007@nokia.com>
Date: Wed, 18 Nov 2009 13:45:23 +0200
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: sameo@linux.intel.com, dbrownell@users.sourceforge.net, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
       lrg@slimlogic.co.uk, adrian.hunter@nokia.com,
       amit.kucheria@verdurent.com, dtor@mail.ru
CC: Valentin Eduardo Bezerra <eduardo.valentin@nokia.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
Subject: [PATCH 0/1] Add all TWL4030 regulators to Regulator framework
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2009 11:45:26.0468 (UTC) FILETIME=[9ECB7840:01CA6844]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds all the remaining TWL4030 regulators into the implementation.
These changes are based on top of Linus' tree master branch, since it is ahead of the mfd-2.6.

Juha Keski-Saari (1):
   Add all TWL regulators to Regulator framework

  drivers/mfd/twl4030-core.c            |   30 ++++++++++++++++++++++++++----
  drivers/regulator/twl4030-regulator.c |   27 +++++++++++++++++----------
  include/linux/i2c/twl4030.h           |    8 ++++++--
  3 files changed, 49 insertions(+), 16 deletions(-)

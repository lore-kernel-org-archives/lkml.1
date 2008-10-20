Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYJTTdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYJTTdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYJTTdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:33:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48306 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753191AbYJTTda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:33:30 -0400
Date: Mon, 20 Oct 2008 20:33:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH 0/2] RTC updates
Message-ID: <20081020193328.GA10272@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes a bug in the RTC core and adds support for the
WM8350 RTC.  The bug fix is required for the WM8350 driver since it does
not support configuration of the year for alarms, triggering the need to
handle year wraparound when reporting the alarm status.

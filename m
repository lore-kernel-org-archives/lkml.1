Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbYKTPUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbYKTPUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbYKTPUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:20:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41451 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754920AbYKTPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:20:46 -0500
Date: Thu, 20 Nov 2008 15:20:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add battery health reporting for WM8350
Message-ID: <20081120152044.GA15434@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: panic: kernel trap (ignored)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This (brief) series adds a new power supply health state for reporting
excessively cold batteries then uses it when implementing battery health
reporting for the WM8350.  I'm not 100% happy with the name for the new
state but I couldn't think of something consistent with the existing
OVERHEAT.

Since the WM8350 PMU driver is queued in the mfd tree it probably makes
sense to merge this via the same path?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582Ab0AHGce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0AHGce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 01:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934Ab0AHGce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 01:32:34 -0500
Received: from trinity.fluff.org ([89.16.178.74]:53916 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab0AHGcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 01:32:33 -0500
From: Ben Dooks <ben-linux@fluff.org>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: GPIO update to allow code to get at gpio_chip
Date: Fri,  8 Jan 2010 06:32:27 +0000
Message-Id: <1262932348-2888-1-git-send-email-ben-linux@fluff.org>
X-Mailer: git-send-email 1.5.6.5
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowing gpiolib implementations to get at the gpio_chip from the
gpio number is useful to allow gpiolib gpio numbering to be used
for other gpio purposes such as changing pin configuration.

The following patch exports this information. A patch showing the
reason for my wanting this can be supplied on request.



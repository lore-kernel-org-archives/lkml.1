Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYEPTiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYEPTiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYEPTh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:37:57 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34201 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYEPTh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:37:56 -0400
Date: Fri, 16 May 2008 13:35:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC PATCH 0/4] Describe SPI devices in the OF device tree and add
	mpc5200-spi driver
To: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Cc: fabrizio.garetto@gmail.com, jonsmirl@gmail.com
Message-id: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a set of changes to allow the slaves on an SPI bus to be
described in the OF device tree (useful in arch/powerpc) and adds a driver
that uses it (the Freescale MPC5200 SoC's SPI device).

Please review and comment.  David, I've included in this series my earlier
patch to change modalias from a pointer to a string as one of the later
patches depends on it.

Cheers,
g.

--
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.

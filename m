Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbXGXE37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbXGXE37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 00:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbXGXE3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 00:29:50 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:38858 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbXGXE3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 00:29:49 -0400
Date: Tue, 24 Jul 2007 06:29:47 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Bill Gatliff <bgat@billgatliff.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: pxa timer code broken for non-CONFIG_GENERIC_CLOCKEVENTS
Message-ID: <20070724042947.GM1678@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill,

7bbb18c9f4783b6fb3bf27af71625b590cf4f00b aka 4507/1 intensively uses
stuff from include/linux/clockchips.h which are defined under

#ifdef CONFIG_GENERIC_CLOCKEVENTS

Unless I'm missing something, all PXA platforms which have
CONFIG_GENERIC_CLOCKEVENTS not set are currently broken and don't
compile any more.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9


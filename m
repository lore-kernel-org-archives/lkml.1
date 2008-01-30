Return-Path: <linux-kernel-owner+w=401wt.eu-S1760422AbYA3OIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbYA3OIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761372AbYA3OHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:07:51 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:49045 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761301AbYA3OHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:07:48 -0500
Message-ID: <47A084B0.1000301@tiscali.nl>
Date: Wed, 30 Jan 2008 15:07:44 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: mchan@broadcom.com, lkml <linux-kernel@vger.kernel.org>
CC: netdev@vger.kernel.org
Subject: [drivers/net/bnx2.c] ADVERTISE_1000XPSE_ASYM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/net/bnx2.c:1285: it reads in function bnx2_setup_remote_phy():

if (pause_adv & (ADVERTISE_1000XPSE_ASYM | ADVERTISE_1000XPSE_ASYM))

Note that the two are the same and this is therefore equivalent to

if (pause_adv & ADVERTISE_1000XPSE_ASYM)

This appears to be incorrect, was maybe '| ADVERTISE_1000XPAUSE' intended?

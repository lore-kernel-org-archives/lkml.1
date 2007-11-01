Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbXKAE7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbXKAE7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXKAE7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:59:36 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:65019 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbXKAE7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:59:35 -0400
Message-ID: <47295D36.8020207@lwfinger.net>
Date: Wed, 31 Oct 2007 23:59:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       dDomen Puncer <domen.puncer@telargo.com>
CC: Dale Farnsworth <dale@farnsworth.org>, Jeff Garzik <jeff@garzik.org>
Subject: Build warning with 2.6.24-rc1: FEC_MPC52xx' refers to undefined symbols
 'PPC_BESTCOMM' and 'PPC_BESTCOMM_FEC'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Using the git sources described as v2.6.24-rc1-659-gb44af9d on x86_64 architecture, I get the
following build warnings:

scripts/kconfig/qconf arch/x86/Kconfig.x86_64
drivers/net/Kconfig:1887:warning: 'select' used by config symbol 'FEC_MPC52xx' refers to undefined
symbol 'PPC_BESTCOMM'
drivers/net/Kconfig:1888:warning: 'select' used by config symbol 'FEC_MPC52xx' refers to undefined
symbol 'PPC_BESTCOMM_FEC'

The offending commit is

commit 5d031e9e7e9ad5aa6516646f955c6262478e1acd
Author: Domen Puncer <domen.puncer@telargo.com>
Date:   Fri Oct 26 18:07:49 2007 +0200

    FEC - fast ethernet controller for mpc52xx

    Driver for ethernet on mpc5200/mpc5200b SoCs (FEC).

    Signed-off-by: Domen Puncer <domen.puncer@telargo.com>
    Acked-by: Dale Farnsworth <dale@farnsworth.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

Larry Finger



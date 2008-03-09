Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYCIUbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYCIUbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYCIUbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:31:13 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:59940 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYCIUbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:31:12 -0400
Message-ID: <47D4490C.7030204@tiscali.nl>
Date: Sun, 09 Mar 2008 21:31:08 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: drzeus-mmc@drzeus.cx
CC: lkml <linux-kernel@vger.kernel.org>
Subject: MMC: logical-bitwise and confusion in  tifm_sd_transfer_data()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from drivers/mmc/host/tifm_sd.c:183:

if ((r_data->flags & MMC_DATA_WRITE)
    && DATA_CARRY)

shouldn't this be bit-wise &?

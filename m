Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbXJNVXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbXJNVXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763871AbXJNVXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:23:36 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:15484 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758621AbXJNVXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:23:35 -0400
From: Frans Pop <pop00041@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: undefined symbol 'APM_EMULATION' during 'make oldconfig' on HPPA
Date: Sun, 14 Oct 2007 23:23:33 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710142323.33820.pop00041@planet.nl>
X-OriginalArrivalTime: 14 Oct 2007 21:23:33.0485 (UTC) FILETIME=[7971B9D0:01C80EA8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

$ git describe
v2.6.23-3345-g52d4e66

$ make oldconfig >/dev/null
drivers/macintosh/Kconfig:121:warning: 'select' used by config 
symbol 'PMAC_APM_EMU' refers to undefined symbol 'APM_EMULATION'

Cheers,
FJP

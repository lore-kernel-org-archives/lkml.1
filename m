Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbZFTBSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbZFTBSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbZFTBRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:17:53 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39062 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750817AbZFTBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:17:52 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2009 21:17:52 EDT
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: PiZ5jvsVM1km9Z8aXfbjz9pRuSVdJFGc6as5vlOyxSel6bFk1wnlEOOH1oEsGdhW0_xUlxf5BbwOBfwWjtmrNTzABrYLuHry8ScyKBNiImGoNSL_Y4EJ_BOjyrIT4OvOsOPIYS6FgEm4zwWbUxJiy1jGAYsKPxL4v_HoajAvoNnpkNHV1Ta_h.dDCLJLjW_02Sxe2Qxg.j37KqYsJrXmpiXBbNMSv.Rrb_ZJO8IE2MrC45QJurI2hC3WHp_LQRqO9IM1NV1LsAJLA7KnX_vldxXUrwoJT0LcKCpGyl3bJXPoXMld7l9ZBq1aysJ8f1cZ3S.72da8hWBaiM2ykepfaOd_KlXlT5yZh3at4XWvZw--
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com
Subject: [PATCH 00/13] revised Coldfire generic GPIO (mk68nommu)
Date: Fri, 19 Jun 2009 18:10:59 -0700
Message-Id: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Revised implementation of generic gpio for the Freescale Coldfire family of
processors (m68knommu).   It uses gpiolib and provides both fast inline
operations when the gpio is a compile time constant and slower outline
operations dispatched via gpiolib when the gpio is a variable. 

There are also hooks for implementing pin multiplexing but that part isn't
finished yet.


The major difference with the previous version is the move to a per-platform
setup code as suggested by Greg Ungerer <gerg@snapgear.com>.

Additionally, it fixes the definition of the TIMER gpio pins in the 5271
(thanks to Richard Retanubun <RichardRetanubun@ruggedcom.com>).

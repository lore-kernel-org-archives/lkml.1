Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbYDVJrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbYDVJrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbYDVJrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:47:14 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:61019 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756784AbYDVJrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:47:13 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-29.messagelabs.com!1208857632!11720050!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Tue, 22 Apr 2008 11:47:08 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] UIO: cleanup and platform driver
Message-ID: <20080422094708.GB27126@digi.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 22 Apr 2008 09:47:09.0183 (UTC) FILETIME=[D4F578F0:01C8A45D]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15864.006
X-TM-AS-Result: No--7.459000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

there are three patches left in my uio queue that didn't made it into
mainline up to now.

You can find the patches in my uio branch at 

	git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git uio

and I will resend the patches as a reply to this mail.

Shortlog and diffstat can be found below.

Best regards
Uwe

Uwe Kleine-König (3):
      UIO: don't let UIO_CIF and UIO_SMX depend twice on UIO
      provide a dummy implementation of the clk API
      UIO: generic platform driver

 drivers/uio/Kconfig    |   10 +++-
 drivers/uio/Makefile   |    1 +
 drivers/uio/uio_pdrv.c |  155 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig            |    6 ++
 lib/Makefile           |    2 +
 lib/dummyclk.c         |   54 +++++++++++++++++
 6 files changed, 226 insertions(+), 2 deletions(-)

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

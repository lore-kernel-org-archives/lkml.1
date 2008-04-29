Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbYD2GpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbYD2GpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYD2Go4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:44:56 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:51771 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYD2Goz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:44:55 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-10.tower-164.messagelabs.com!1209451493!9187450!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Tue, 29 Apr 2008 08:44:08 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <dbrownell@users.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>
Subject: rtc_valid_tm doesn't check tm_wday
Message-ID: <20080429064408.GA8352@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 29 Apr 2008 06:44:09.0337 (UTC) FILETIME=[6D5A2E90:01C8A9C4]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15878.004
X-TM-AS-Result: No--3.904000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm currently writing an rtc driver and want to use rtc_valid_tm to
assert to have a valid date before writing it to the rtc.

Now I wonder why rtc_valid_tm doesn't check tm_wday for being in the
range [0 .. 6].  Is there a reason?  I could imagine that you want to
be able to check paritial "struct rtc_time"s, too.

So should I check tm_wday myself?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

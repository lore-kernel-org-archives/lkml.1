Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYD2MXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYD2MXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYD2MXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:23:04 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:42957 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbYD2MXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:23:03 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-164.messagelabs.com!1209471776!11042473!6
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Tue, 29 Apr 2008 14:22:45 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: David Brownell <david-b@pacbell.net>
CC: Alessandro Zummo <a.zummo@towertech.it>, <linux-kernel@vger.kernel.org>
Subject: Re: rtc_valid_tm doesn't check tm_wday
Message-ID: <20080429122245.GB2137@digi.com>
References: <20080429064408.GA8352@digi.com> <200804290340.16642.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804290340.16642.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 29 Apr 2008 12:22:46.0096 (UTC) FILETIME=[BB159500:01C8A9F3]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15878.007
X-TM-AS-Result: No--19.321000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

David Brownell wrote:
> On Monday 28 April 2008, Uwe Kleine-König wrote:
> > Hello,
> > 
> > I'm currently writing an rtc driver and want to use rtc_valid_tm to
> > assert to have a valid date before writing it to the rtc.
> > 
> > Now I wonder why rtc_valid_tm doesn't check tm_wday for being in the
> > range [0 .. 6].  Is there a reason?
> 
> As far as I know, the kernel doesn't use tm_wday, tm_yday, or
> tm_isdst ... so none of those fields are expected to be valid.
> See the rtc(4) manpage.
Thanks.

I still want to write the correct value to the rtc, so I will assert
dirctly in the driver that it's valid.

Best regards,
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

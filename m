Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYDJUMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYDJUMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbYDJUMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:12:08 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:14984 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757388AbYDJUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:12:05 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-14.tower-29.messagelabs.com!1207858325!10563985!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Thu, 10 Apr 2008 22:11:03 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] UIO: hold a reference to the device's owner while the device is open
Message-ID: <20080410201103.GB16292@digi.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Apr 2008 20:11:03.0511 (UTC) FILETIME=[00999E70:01C89B47]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15842.001
X-TM-AS-Result: No--8.293000-8.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:
> Otherwise the device might just disappear while /dev/uioX is being used
> which results in an Oops.
To help your understanding, without this patch I can trigger the Oops
by starting an app that does

	opening and mmapping /dev/uio0
	while(1);

and then in another shell do 

	rmmod uio_pdrv

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

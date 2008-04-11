Return-Path: <linux-kernel-owner+w=401wt.eu-S1760244AbYDKKtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244AbYDKKtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759395AbYDKKsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:48:54 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:11917 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758944AbYDKKsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:48:53 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-164.messagelabs.com!1207910932!12587900!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Fri, 11 Apr 2008 12:48:35 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v2] [RFC] UIO: generic platform driver
Message-ID: <20080411104835.GB19973@digi.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410224804.GI3193@local> <20080411062106.GA18096@digi.com> <20080411092158.GB31625@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080411092158.GB31625@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Apr 2008 10:48:35.0271 (UTC) FILETIME=[977E9D70:01C89BC1]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15842.003
X-TM-AS-Result: No--11.286000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Uwe Kleine-König wrote:
> +			dev_warn(&pdev->dev, "device has more than "
> +					stringify(MAX_UIO_MAPS)
This must read __stringify(MAX_UIO_MAPS).  Sorry, I didn't compile test
that.

Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

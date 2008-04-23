Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYDWI5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYDWI5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYDWI53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:57:29 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:35109 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbYDWI52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:57:28 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-6.tower-164.messagelabs.com!1208941041!5729879!2
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Wed, 23 Apr 2008 10:56:29 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] UIO: generic platform driver
Message-ID: <20080423085629.GA16776@digi.com>
References: <20080422094708.GB27126@digi.com> <1208857977-29493-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1208857977-29493-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1208857977-29493-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1208857977-29493-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 Apr 2008 08:56:30.0672 (UTC) FILETIME=[EC473D00:01C8A51F]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1026-15866.005
X-TM-AS-Result: No--11.427700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> ---
> Hello,
> 
> This is the former patch 4/4 after some discussion.
> 
> Open issues:
>   - clock name "uio" isn't considered good by Russell King
>     I don't have a better suggestion
I added another branch[1] on my repo that doesn't have the dummy clk
patch and variant of this one that doesn't use the clk API.

This way the clk API isn't needed anymore for my patch and the issue
about the clock name disappeard, too.

Best regards
Uwe

[1] git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git uio2
-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZF3XO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZF3XO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZF3XOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:14:47 -0400
Received: from ru.mvista.com ([213.79.90.228]:22457 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752949AbZF3XOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:14:47 -0400
Date: Wed, 1 Jul 2009 03:14:50 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       richard@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Fox <pgf@laptop.org>, dsaxena@laptop.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 5/5] power_supply: add a charge_type status to the api,
 and use it for olpc driver
Message-ID: <20090630231450.GD12076@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090630021730.44f86185@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090630021730.44f86185@mycelium.queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 02:17:30AM -0400, Andres Salomon wrote:
> 
> This adds a new sysfs file called 'charge_type' which displays the type of
> charging (n/a, trickle charge, slow charge, or fast charging).  This allows
> things like battery diagnostics to determine what the battery/EC is doing
> without resorting to changing the 'status' sysfs output.
> 
> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> ---

The patch didn't apply cleanly (not sure why, maybe because
of my "cosmetic" changes in the previous patches? hm.)

Can you please add "Unknown" state before "N/A", and
per Mark's comments also remove "Slow" charge type, and
resend the patch against battery-2.6.git tree?

Mark, since you seem to be interested in this addition, it
would be great to see your ack/nak status on an updated
patch, so we'll be sure that this is suitable for WM8350.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

Return-Path: <linux-kernel-owner+w=401wt.eu-S934603AbZHEO5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934603AbZHEO5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934538AbZHEO5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:57:51 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:50847 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934534AbZHEO5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:57:50 -0400
From: Frans Pop <elendil@planet.nl>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH 1/2] ds2760: switch to new dev_pm_ops
Date: Wed, 5 Aug 2009 16:57:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, daniel@caiaq.de, szabolcs.gyurko@tlt.hu,
       mreimer@vpop.net, cbou@mail.ru
References: <1249476387-27325-1-git-send-email-daniel@caiaq.de>
In-reply-To: <1249476387-27325-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908051657.49810.elendil@planet.nl>
X-OriginalArrivalTime: 05 Aug 2009 14:57:50.0485 (UTC) FILETIME=[1A30EC50:01CA15DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> +static struct dev_pm_ops ds2760_battery_pm_ops = {
> +       .suspend        = ds2760_battery_suspend,
> +       .resume         = ds2760_battery_resume,
> +};

Just to make sure...

Have you followed the earlier discussions on dev_pm_ops conversions and 
are you aware that if done like this the driver no longer supports 
hibernation?

If omitting hibernation is intentional, it should probably be justified in 
the commit log.

See http://lkml.org/lkml/2009/7/25/118 for background.

Same goes for your patch for w1_gpio of course.

Cheers,
FJP

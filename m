Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbZDDWDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbZDDWDr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 18:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZDDWDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 18:03:37 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:64847 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751879AbZDDWDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 18:03:37 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Warn if interrupts are enabled during suspend-resume of sysdevs
Date: Sun, 5 Apr 2009 00:03:31 +0200
User-Agent: KMail/1.9.9
Cc: lenb@kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
References: <200904042323.19866.rjw@sisk.pl>
In-reply-To: <200904042323.19866.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200904050003.33609.elendil@planet.nl>
X-OriginalArrivalTime: 04 Apr 2009 22:03:34.0483 (UTC) FILETIME=[32CA7230:01C9B571]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n34M3squ012140

> @@ -377,6 +381,9 @@ int sysdev_suspend(pm_message_t state)>         if (ret)>                 return ret;>  > +       WARN_ONCE(!irqs_disabled(),> +               "Interrupts enabled while suspending system devices");> +
Missing \n ?
> @@ -452,6 +465,9 @@ int sysdev_resume(void)>  {>         struct sysdev_class *cls;>  > +       WARN_ONCE(!irqs_disabled(),> +               "Interrupts enabled while resuming system devices");> +
Again.
Cheers,FJPÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

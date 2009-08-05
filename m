Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZHETt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZHETt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbZHETt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:49:57 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:52872 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbZHETt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:49:56 -0400
From: Frans Pop <elendil@planet.nl>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH 2/5] pda-power: switch to new dev_pm_ops
Date: Wed, 5 Aug 2009 21:49:52 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       daniel@caiaq.de, spyro@f2s.com, cbou@mail.ru, mreimer@vpop.net
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de> <1249496971-9019-1-git-send-email-daniel@caiaq.de> <1249496971-9019-2-git-send-email-daniel@caiaq.de>
In-reply-To: <1249496971-9019-2-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908052149.55567.elendil@planet.nl>
X-OriginalArrivalTime: 05 Aug 2009 19:49:56.0578 (UTC) FILETIME=[E88E7C20:01CA1605]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> +static struct dev_pm_ops pda_power_pm_ops = {
> +       .suspend        = pda_power_suspend,
> +       .freeze         = pda_power_freeze,

Hmmm. Where's pda_power_freeze defined? Forgot to (compile)test the 
patches?

> +       .resume         = pda_power_resume,
> +       .thaw           = pda_power_resume,

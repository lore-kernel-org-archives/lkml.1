Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYKYL0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYKYL0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYKYL0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:26:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:28039 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbYKYL0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:26:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g2vgmk2pOz2AKGJzjtkIW5N2ifCrOFx3mt8EcwaiXlvtynRBQfT2BjBNsyeDF4yYlR
         Dw76/LMdLZNMRKE0UW9yKK29YEV37UpFw6ImWO/sZZ3gu5Pd9AUYgi0K0gDH6OVpqZ2+
         5M5hmsYwFPEXkDlInIILye3f9SWaqkCvLqLj0=
Date: Tue, 25 Nov 2008 14:26:17 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] power_supply: Add battery health reporting for
	WM8350
Message-ID: <20081125112617.GB1110@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20081120152044.GA15434@rakim.wolfsonmicro.main> <1227194621-16442-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1227194621-16442-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1227194621-16442-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 03:23:41PM +0000, Mark Brown wrote:
> Implement support for reporting battery health in the WM8350 battery
> interface. Since we are now able to report this via the classs remove
> the diagnostics from the interrupt handler.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

> ---
>  drivers/mfd/wm8350-regmap.c     |    2 +-
>  drivers/power/wm8350_power.c    |   33 +++++++++++++++++++++++++--------
>  include/linux/mfd/wm8350/core.h |    7 +++++++
>  3 files changed, 33 insertions(+), 9 deletions(-)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

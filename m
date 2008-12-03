Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbYLCJXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbYLCJXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 04:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYLCJXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 04:23:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbYLCJXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 04:23:24 -0500
Date: Wed, 3 Dec 2008 01:23:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: philipl@overt.org
Cc: "linux kernel" <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Frans Pop" <elendil@planet.nl>
Subject: Re: [PATCH] ricoh_mmc: Use suspend/resume_noirq (resend)
Message-Id: <20081203012300.737b5b61.akpm@linux-foundation.org>
In-Reply-To: <60072.67.164.5.76.1228094920.squirrel@overt.org>
References: <60072.67.164.5.76.1228094920.squirrel@overt.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2008 20:28:40 -0500 (EST) philipl@overt.org wrote:

> +static struct pm_ext_ops ricoh_mmc_pm_ext_opts = {
> +	.suspend_noirq =	ricoh_mmc_suspend_noirq,
> +	.resume_noirq =		ricoh_mmc_resume_noirq,
> +};

pm_ext_ops got deleted from linux-next.

commit 481617dc3d1e6c52e35172ab49e655f74a1591b6
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Oct 6 22:46:05 2008 +0200

    PM: Simplify the new suspend/hibernation framework for devices
    


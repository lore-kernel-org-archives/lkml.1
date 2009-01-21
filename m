Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbZAUO5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbZAUO5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZAUO5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:57:47 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:36380 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbZAUO5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:57:46 -0500
Subject: Re: [PATCH] regulator: Hoist struct regulator_dev out of core to
 fix notifiers
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jonathan Cameron <jic23@cam.ac.uk>
In-Reply-To: <1232546920-14915-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232546920-14915-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 14:57:43 +0000
Message-Id: <1232549863.16911.350.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 14:08 +0000, Mark Brown wrote:
> Commit 872ed3fe176833f7d43748eb88010da4bbd2f983 caused regulator drivers
> to take the struct regulator_dev lock themselves which requires that the
> struct be visible to them. Band aid this by making the struct visible.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c         |   27 ---------------------------
>  include/linux/regulator/driver.h |   32 ++++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 27 deletions(-)

Applied and fixed.

Thanks

Liam


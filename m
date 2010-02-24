Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab0BXKZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:25:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44935 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756465Ab0BXKZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:25:50 -0500
Date: Wed, 24 Feb 2010 10:25:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] Regulators: wm8400 - cleanup platform driver
 data handling
Message-ID: <20100224102548.GG18896@rakim.wolfsonmicro.main>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073849.15964.62321.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224073849.15964.62321.stgit@localhost.localdomain>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 11:38:50PM -0800, Dmitry Torokhov wrote:
> Driver data set by platform_set_drvdata() is for private use of
> the driver currently bound to teh device and not for use by parent,
> subsystem and anyone else.
> 
> Also have wm8400_register_regulator() accept 'sturct wm8400 *'
> instead of generic device structure.

Nack due to this change - this change would make it impossible for
callers to actually call the function.  Note that nothing including only
wm8400.h even has a struct declaration, much less defniition, for struct
wm8400.

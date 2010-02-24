Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0BXMLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 07:11:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36378 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756211Ab0BXMLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 07:11:35 -0500
Date: Wed, 24 Feb 2010 12:11:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14] Regulators: lp3971 - fail if platform data was
 not supplied
Message-ID: <20100224121133.GO18896@rakim.wolfsonmicro.main>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073817.15964.82625.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224073817.15964.82625.stgit@localhost.localdomain>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 11:38:17PM -0800, Dmitry Torokhov wrote:
> There is no point in completing probe if platform data is missing so
> let's abort loading early.
> 
> Also, use kcalloc when allocating several instances of the same data
> structure and mark setup_regulators() as __devinit since it is only
> called from lp3971_i2c_probe() which is __devinit.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but this *really* should have been split into multiple patches, there's
a large number of different changes mixed in here, with random coding
style tweaks overlapping with substantial changes to the handling of
probe.

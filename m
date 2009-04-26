Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZDZJYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZDZJYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZDZJXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:23:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59780 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751850AbZDZJXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:23:49 -0400
Date: Sun, 26 Apr 2009 10:23:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] regulator core: fix double-free in
	regulator_register() error path
Message-ID: <20090426092344.GA9009@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 05:28:36AM -0600, Paul Walmsley wrote:

> During regulator registration, any error after device_register() will 
> cause a double-free on the struct regulator_dev 'rdev'.  The bug is in 
> drivers/regulator/core.c:regulator_register():

Looks good:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

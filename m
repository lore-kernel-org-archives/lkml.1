Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZHGQCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZHGQCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbZHGQCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:02:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60419 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbZHGQCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:02:53 -0400
Date: Fri, 7 Aug 2009 17:02:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anuj Aggarwal <anuj.aggarwal@ti.com>
Cc: lrg@slimlogic.co.uk, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Regulator: Add TPS6507x regulator driver
Message-ID: <20090807160253.GK639@sirena.org.uk>
References: <1249658766-10859-1-git-send-email-anuj.aggarwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249658766-10859-1-git-send-email-anuj.aggarwal@ti.com>
X-Cookie: Sic Transit Gloria Thursdi.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 08:56:06PM +0530, Anuj Aggarwal wrote:
> Adding support for TI TPS6507x regulator driver

Exactly which chips does this driver support?  Google tells me that at
least some of the parts in the TPS6507x range have functionality other
than regulator support on them like power path management and touch
which would mean that the drivers should be using the MFD framework to
hook in to the various subsystems unless the device presents as multiple
devices on the I2C bus.

Otherwise my comments here are essentially the same as for the previous
driver - it looks good but the same relatively minor issues apply.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZFZJvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZFZJvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZFZJvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:51:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52031 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZFZJvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:51:21 -0400
Date: Fri, 26 Jun 2009 10:51:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
       linux-i2c@vger.kernel.org, lm-sensors@lm-sensors.org,
       suchang.woo@samsung.com, kyungmin.park@samsung.com
Message-ID: <20090626095116.GD5415@sirena.org.uk>
References: <4A448926.1030701@samsung.com>
 <1246007760.3067.5.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246007760.3067.5.camel@hpdv5.satnam>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] hwmon: add GP2A002 proximity/ambient sensor
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 02:46:00PM +0530, Jaswinder Singh Rajput wrote:

> I am curious what is the use of include/linux/gp2ap002.h, it only have
> gp2ap002_platform_data structure which you can keep in your source file
> the only file which is using it.

Platform data is data which is passed in from the board-specific code
for the system (which will live under arch) to configure the driver.

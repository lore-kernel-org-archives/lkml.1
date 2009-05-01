Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZEALZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZEALZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZEALZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:25:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40447 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZEALZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:25:27 -0400
Date: Fri, 1 May 2009 12:25:25 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mfd: remove driver_data direct access of struct device
Message-ID: <20090501112525.GD6975@sirena.org.uk>
References: <20090430221850.GA18541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430221850.GA18541@kroah.com>
X-Cookie: She sells cshs by the cshore.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:18:50PM -0700, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>

> In the near future, the driver core is going to not allow direct access
> to the driver_data pointer in struct device.  Instead, the functions
> dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> have been around since the beginning, so are backwards compatible with
> all older kernel versions.

> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

For wm8400:

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

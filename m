Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZEAJTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZEAJTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbZEAJTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:19:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59992 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754868AbZEAJTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:19:31 -0400
Date: Fri, 1 May 2009 10:19:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: remove driver_data direct access of struct
	device
Message-ID: <20090501091928.GA3339@rakim.wolfsonmicro.main>
References: <20090430222137.GA18614@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430222137.GA18614@kroah.com>
X-Cookie: I can't drive 55.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:21:37PM -0700, Greg Kroah-Hartman wrote:

> In the near future, the driver core is going to not allow direct access
> to the driver_data pointer in struct device.  Instead, the functions
> dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> have been around since the beginning, so are backwards compatible with
> all older kernel versions.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

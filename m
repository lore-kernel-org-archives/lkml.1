Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbXJIUkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbXJIUkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbXJIUkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:40:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56987 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbXJIUj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:39:59 -0400
Date: Tue, 9 Oct 2007 13:40:37 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       haveblue@us.ibm.com
Subject: Re: [PATCH v4] IBM power meter driver
Message-ID: <20071009204037.GF16003@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164905.GM32667@tree.beaverton.ibm.com> <20070828232504.GP32667@tree.beaverton.ibm.com> <20070911132335.GJ31992@jupiter.solarsys.private> <20070914193346.GM30825@tree.beaverton.ibm.com> <20071009120044.GP3835@jupiter.solarsys.private> <470BAFD7.10305@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470BAFD7.10305@tiscali.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 06:44:07PM +0200, Roel Kluin wrote:

> >> +	if (IS_ERR(data->hwmon_dev)) {
> >> +		printk(KERN_ERR DRVNAME ": Error, unable to register hwmon "
> >> +		       "class device for interface %d\n",
> >> +		       data->interface);
> >> +		kfree(data);
> >> +		return;
> 
> don't you want to goto out_user here instead?

Err, yes, thank you for catching that.

--D

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148Ab0AHV1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0AHV1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003Ab0AHV1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:27:09 -0500
Received: from lixom.net ([66.141.50.11]:58586 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930Ab0AHV1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:27:08 -0500
Date: Fri, 8 Jan 2010 15:34:15 -0600
From: Olof Johansson <olof@lixom.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, ben-linux@fluff.org,
       linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] pca953x: Minor include cleanup
Message-ID: <20100108213415.GA23113@lixom.net>
References: <20100105201042.GA28367@lixom.net> <20100105202158.GB4848@pengutronix.de> <20100106121722.6e2598ec@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106121722.6e2598ec@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 12:17:22PM +0100, Jean Delvare wrote:
> On Tue, 5 Jan 2010 21:21:58 +0100, Wolfram Sang wrote:
> > On Tue, Jan 05, 2010 at 02:10:42PM -0600, Olof Johansson wrote:
> > > linux/i2c/pca953x.h is a very bare include file. Fix check for multiple
> > > includes of linux/i2c/pca953x.h, and add dependent includes into the
> > > header file.
> > > 
> > > Signed-off-by: Olof Johansson <olof@lixom.net>
> > 
> > Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> 
> And also
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>
> 
> Note though that this file is not part of the i2c subsystem. Your patch
> is something for the gpio people.

Boggle. No GPIO maintianer (nor list) mentioned in MAINTAINERS. I
don't see any common merge paths in the git log of drivers/gpio either,
besides akpm.

So I guess I'll ask him to pick it up.

Andrew: Want a fresh copy of the patch?


-Olof

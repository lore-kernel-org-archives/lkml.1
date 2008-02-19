Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYBSKBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYBSKBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYBSKBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:01:37 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:3314 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754534AbYBSKBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:01:37 -0500
Date: Tue, 19 Feb 2008 10:53:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] adt7473: New driver for Analog Devices  ADT7473 sensor
 chip
Message-ID: <20080219105317.11c22ca9@hyperion.delvare>
In-Reply-To: <20080217200250.GD2916@jupiter.solarsys.private>
References: <20071219034116.GM6870@tree.beaverton.ibm.com>
	<20071219154759.7be5025c@hyperion.delvare>
	<20071219231437.GR6870@tree.beaverton.ibm.com>
	<20080217200250.GD2916@jupiter.solarsys.private>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 15:02:50 -0500, Mark M. Hoffman wrote:
> * Darrick J. Wong <djwong@us.ibm.com> [2007-12-19 15:14:38 -0800]:
> > +static int adt7473_attach_adapter(struct i2c_adapter *adapter)
> > +{
> > +	/*
> > +	 * Some NVIDIA cards have an adt7473 attached to the on-board
> > +	 * i2c controller, but the i2c adapter driver in the binary
> > +	 * nvidia superblob driver sets class to 0.
> > +	 */
> > +	if (!(adapter->class & I2C_CLASS_HWMON) && adapter->class)
> > +		return 0;
> 
> NACK on that comment and associated code:  Jean Delvare submitted a
> patch to NVIDIA over two years ago to fix their bug.  Apparently some
> distros even carry his patch.  So, I don't want to encourage such a
> hack to persist.  Please just do the standard check here.

For the records: this patch exists but I did not send it to nVidia. For
legal/license reasons I do not want to be considered a contributor to
the nvidia Linux driver. So someone else will have to send the patch to
nVidia. I would hope that this was already done by now, but maybe not.

-- 
Jean Delvare

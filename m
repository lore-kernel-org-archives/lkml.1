Return-Path: <linux-kernel-owner+w=401wt.eu-S969197AbXFHNe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969197AbXFHNe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967760AbXFHNeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:34:22 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:3229 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967831AbXFHNeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:34:21 -0400
Date: Fri, 8 Jun 2007 15:35:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <greg@kroah.com>, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: i2c@lm-sensors.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [i2c] i2c module aliases
Message-ID: <20070608153516.28fd9eb5@hyperion.delvare>
In-Reply-To: <20070607160214.GB17800@kroah.com>
References: <Pine.LNX.4.64.0706062325270.30244@anakin>
	<20070607175342.3006e872@hyperion.delvare>
	<20070607160214.GB17800@kroah.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 09:02:14 -0700, Greg KH wrote:
> On Thu, Jun 07, 2007 at 05:53:42PM +0200, Jean Delvare wrote:
> > Looks correct. However I am curious what this "i2c->id" is supposed to
> > represent, given that I2C devices do not have any form of ID as PCI or
> > USB devices have. No driver uses "MODULE_DEVICE_TABLE(i2c, ...)"
> > probably just because it doesn't make sense. So, rather than fixing
> > this, shouldn't we simply wipe out struct i2c_device_id? Greg, David?
> 
> If no one is using it, then yes, it should be removed.
> 
> Sorry, I added it a while ago thinking it was going to be used (I had
> test patches using it in my tree, but they never worked out in the end.)

OK. Geert, care to submit a new patch removing struct i2c_device_id
altogether?

Thanks,
-- 
Jean Delvare

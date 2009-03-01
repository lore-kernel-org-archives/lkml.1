Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbZCAMw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbZCAMw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 07:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZCAMwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 07:52:19 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:33101 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZCAMwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 07:52:19 -0500
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Mar 2009 07:52:18 EST
Date: Sun, 1 Mar 2009 13:41:34 +0100
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>
Subject: Where to put new sensor drivers?
Message-ID: <20090301124134.GE20813@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote a driver for an I2C connected ambient light sensor and submitted
it to the linux-i2c list[1]. In the first place, I wasn't aware of
drivers/i2c/chips being deprecated and hencei, I subsequently moved it to
what seemed to match best in the current tree, drivers/hwmon. But as
Jean Delvare pointed out, this is not the place for it either because it
doesn't really monitor the hardware, which is true.

So I posted a proposal[2] patch series that adds drivers/sensors for
such cases (some of the drivers in the legacy folder drivers/i2c/chips
have the same problem than my new one has) but haven't got reply on it
yet, probably because linux-i2c is the wrong place to ask.

Maybe someone here has an oppinon about that?


Thanks,
Daniel


[1] http://article.gmane.org/gmane.linux.drivers.i2c/3148
[2] http://article.gmane.org/gmane.linux.drivers.i2c/3159


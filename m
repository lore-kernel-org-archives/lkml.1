Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbZCANaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbZCANaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 08:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZCAN37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 08:29:59 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:36683 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbZCAN36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 08:29:58 -0500
Date: Sun, 1 Mar 2009 14:29:53 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Pavel Machek <pavel@suse.cz>,
       =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org
Subject: lis3's ACPI dependency
Message-ID: <20090301132953.GF20813@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, Eric,

are there any plans to free the lis3 driver from its ACPI dependency?
In fact, this device is I2C/SPI connected which the ACPI layer seems to
hide from the driver, but to use it on embedded devices, the bus drivers
must be used directly and the dependeny seems entirely unnecessary
anyway.

Also I got the feeling that using a globally exported 'adev' symbol all
over the different layers is not the best practice - I suspect all the
occasions could be solved with private pointers and/or container_of().
Isn't there any cleanup pending?

Thanks and best regards,
Daniel


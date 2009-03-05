Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZCEPDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZCEPDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZCEPDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:03:41 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:39017 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZCEPDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:03:40 -0500
Date: Thu, 5 Mar 2009 16:03:34 +0100
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Where to put new sensor drivers?
Message-ID: <20090305150334.GC29699@buzzloop.caiaq.de>
References: <20090301124134.GE20813@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301124134.GE20813@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 01:41:34PM +0100, Daniel Mack wrote:
> I wrote a driver for an I2C connected ambient light sensor and submitted
> it to the linux-i2c list[1]. In the first place, I wasn't aware of
> drivers/i2c/chips being deprecated and hencei, I subsequently moved it to
> what seemed to match best in the current tree, drivers/hwmon. But as
> Jean Delvare pointed out, this is not the place for it either because it
> doesn't really monitor the hardware, which is true.
> 
> So I posted a proposal[2] patch series that adds drivers/sensors for
> such cases (some of the drivers in the legacy folder drivers/i2c/chips
> have the same problem than my new one has) but haven't got reply on it
> yet, probably because linux-i2c is the wrong place to ask.

Hmm, no feedback here either? I was pointed to the 'industrial I/O'
thread[1], but that one didn't go mainline yet, and I didn't find any
reference of someone picking up this idea.

Are such drivers not wanted in the kernel? I could also move my code to
userspace, but I though if it's supported by the kernel, more people
can acutally use it easily.

Daniel

[1] http://lkml.org/lkml/2008/12/1/156


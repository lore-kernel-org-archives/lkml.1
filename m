Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYHGSkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYHGSkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYHGSko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:40:44 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:41371 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbYHGSkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:40:43 -0400
Date: Thu, 7 Aug 2008 20:39:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: "D. Kelly" <user.kernel@gmail.com>,
       "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Message-ID: <20080807183944.GA29207@uranus.ravnborg.org>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com> <20080807131357.59399ddf@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807131357.59399ddf@hyperion.delvare>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Alternatively, I am curious if our build system couldn't allow 3rd
> party drivers to select in-tree modules. Obviously this would require
> the complete kernel source tree to be available, instead of just the
> header and config files as is usually the case. Sam, is this possible
> to do that at this time? If not, is this something that could be
> implemented, or is this too much work for the thin benefit?

In general I recommnd to have the full kernel source available
simply because we have no in-kernel solution to create the required
set of files to build external modules.

And today there is no way to hook into the kernel configuration
for an external module. First of we cannot allow changes in
the build kernel module as this would destroy module versioning
for instance.

And in this case you ask because you would change the kernel
configuration.

And I fail to see why this stuff cannot be done inside the
kernel source tree. Merging new kernel updates should be absolutely
trivial and then the drivers are better prepared for upstream anyway.

	Sam

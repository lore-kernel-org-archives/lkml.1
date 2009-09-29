Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZI2Wk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZI2Wk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 18:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZI2Wk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 18:40:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbZI2Wk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 18:40:26 -0400
Date: Tue, 29 Sep 2009 15:39:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       michael.hennerich@analog.com, chrisv@cyberswitching.com
Subject: Re: [PATCH] ad525x_dpot: new driver for AD525x digital
 potentiometers
Message-Id: <20090929153902.ab74aa01.akpm@linux-foundation.org>
In-Reply-To: <1253161357-22453-1-git-send-email-vapier@gentoo.org>
References: <1253161357-22453-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 00:22:37 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> This driver supports the non-volatile digital potentiometers via I2C:
> AD5258, AD5259, AD5251, AD5252, AD5253, AD5254, and AD5255
> 
> It provides a sysfs interface to each device for reading/writing.

This sysfs interface is by far the most important aspect of this
driver.  For both its users and for its reviewers.

Yet you tell us nothing about it!  Not in code comments, not in the
changelog, not in supporting documentation.

So some poor idiot (ie: me) is left having to scratch his way through
the implementation trying to work out what the propoed userspace
interface is supposed to look like.

Then I come across something this:

+	if (reg & AD525X_REG_TOL)
+		return sprintf(buf, "0x%04x\n", value & 0xFFFF);
+	else
+		return sprintf(buf, "%u\n", value & data->rdac_mask);

which makes me suspect that the proposed userspace interface is quite
poor.


Patch not applied!  Not even close.

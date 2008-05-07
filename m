Return-Path: <linux-kernel-owner+w=401wt.eu-S1763801AbYEGHKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763801AbYEGHKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYEGHKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:10:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbYEGHKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:10:20 -0400
Date: Wed, 7 May 2008 00:08:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
Message-Id: <20080507000853.17f1316b.akpm@linux-foundation.org>
In-Reply-To: <20080507085953.2c08b854@hyperion.delvare>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
	<20080507085953.2c08b854@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 08:59:53 +0200 Jean Delvare <khali@linux-fr.org> wrote:

> I'm not sure how you intend to push these changes upstream. I would
> take a patch only touching drivers/i2c/busses/i2c-sibyte.c in my i2c
> tree, however a patch also touching arch code, must be handled be the
> maintainer for that architecture or platform.

Not "must".  The arch maintainer could ask you to merge it or you could ask
the arch maintainer to merge it.

It's some little one-line change like this one appeared to be, it's
fair to assume the arch maintainer won't care much about it.  View it as an
i2c patch?


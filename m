Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbXFZFW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbXFZFW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXFZFWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:22:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbXFZFWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:22:20 -0400
Date: Mon, 25 Jun 2007 22:21:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, ab@mycable.de, mgreer@mvista.com,
       khali@linux-fr.org, david-b@pacbell.net
Subject: Re: [PATCH 1/2] rtc: add rtc-m41t80 driver
Message-Id: <20070625222142.e9215829.akpm@linux-foundation.org>
In-Reply-To: <20070626.141536.126143027.nemoto@toshiba-tops.co.jp>
References: <20070621.020934.59464708.anemo@mba.ocn.ne.jp>
	<20070625214620.6a48a02a.akpm@linux-foundation.org>
	<20070626.141536.126143027.nemoto@toshiba-tops.co.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 14:15:36 +0900 (JST) Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> On Mon, 25 Jun 2007 21:46:20 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > +	const static struct m41t80_chip_info *chip;
> > 
> > It's a bit weird that `chip' has static storage class here.  Was that
> > deliberate?
> 
> Oh the variable should not be static!
> I will send updated patch.

I'll fix it up.

> BTW, I reveived following mails:
> 
> Subject: - rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch removed from -mm tree
> Subject: - rtc-add-rtc-m41t80-driver-take-2.patch removed from -mm tree
> Subject: + rtc-add-rtc-m41t80-driver.patch added to -mm tree
> Subject: + rtc-watchdog-support-for-rtc-m41t80-driver.patch added to -mm tree
> 
> Are you going back to "take 1" patches?  Why?

Stupidity, apparently.  Will restore the take2 patches.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXCSUGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXCSUGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXCSUGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:06:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46870
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbXCSUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:05:43 -0400
Date: Mon, 19 Mar 2007 13:05:44 -0700 (PDT)
Message-Id: <20070319.130544.115907938.davem@davemloft.net>
To: jesse.barnes@intel.com
Cc: zaitcev@redhat.com, jg@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: BSOD
From: David Miller <davem@davemloft.net>
In-Reply-To: <200703191254.36373.jesse.barnes@intel.com>
References: <20070319120807.af36ef5d.zaitcev@redhat.com>
	<20070319.123836.39155546.davem@davemloft.net>
	<200703191254.36373.jesse.barnes@intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jesse.barnes@intel.com>
Date: Mon, 19 Mar 2007 12:54:36 -0700

> Kernel based modesetting should get us a lot of things:

But for panics you're ignoring what Peter and I are saying.

Mode setting is complex and it is not going to work exactly when you
need the kernel crash message the most.

After debugging the kernel for 10+ years I can tell you one thing, for
a bad crash what's going to happen is you'll get the printk but that's
about all that will work at that point, and the kernel is going to
hang next.  Sometimes you won't get the whole panic message, just
the beginning, even with the most simplistic printk implementation.

You will not, I repeat, will not be able to mode switch or anything
non-trivial like that when the kernel is in this state.

Mode switching on panic, just say no. :-)


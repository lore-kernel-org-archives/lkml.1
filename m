Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZIQJdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZIQJdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZIQJdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:33:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41511 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752192AbZIQJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:33:03 -0400
Date: Thu, 17 Sep 2009 10:33:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Convert WM8350 to use request_threaded_irq()
Message-ID: <20090917093304.GA30736@rakim.wolfsonmicro.main>
References: <1253124452-10318-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090917090155.GB18862@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917090155.GB18862@sortiz.org>
X-Cookie: Do, or do not
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 11:01:56AM +0200, Samuel Ortiz wrote:
> On Wed, Sep 16, 2009 at 07:07:32PM +0100, Mark Brown wrote:

> > Instead of hand rolling our own variant.

> Very nice. I expect many other mfd drivers will eventually go the same way.
> I'll look at the ones I have HW for.

I've got a patch sitting waiting to convert wm831x completely to genirq,
including changing to use threaded IRQ handlers.  It'll probably be
after the merge window before I finish up testing and post it.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752045AbZJUM2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbZJUM2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 08:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZJUM2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 08:28:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34655 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZJUM2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 08:28:06 -0400
Date: Wed, 21 Oct 2009 13:27:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] serial/atmel_serial: Fix another fallout of the change
	to BUILD_BUG_ON
Message-ID: <20091021122709.GA332@n2100.arm.linux.org.uk>
References: <1255417680-25609-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091013092644.72c78334@hskinnemoen-d830> <20091013082447.GA3194@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091013082447.GA3194@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 10:24:47AM +0200, Uwe Kleine-König wrote:
> Hello Andrew,
> 
> On Tue, Oct 13, 2009 at 09:26:44AM +0200, Haavard Skinnemoen wrote:
> > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> > > Commit 8c87df457cb5 fixed BUILD_BUG_ON with the result that some
> > > expressions (e.g. "not really constant" ones) result in a build failure.
> > > 
> > > Some of these were fixed in 8c87df457cb5, but not serial/atmel_serial.
> > 
> > This patch fixes the same issue:
> > 
> > http://lkml.org/lkml/2009/10/6/305
> Can you please take this and add my Ack?
> 
> If you cannot find it anymore in your inbox, you can get it from
> http://article.gmane.org/gmane.linux.kernel/898575/raw

So what's happening with this?

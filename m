Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZGVP4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZGVP4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZGVP4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:56:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44830 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752718AbZGVP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:56:17 -0400
Date: Wed, 22 Jul 2009 16:56:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090722155615.GA14026@rakim.wolfsonmicro.main>
References: <20090721222547.GA1948@opensource.wolfsonmicro.com>
 <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain>
 <20090722121800.GD21171@rakim.wolfsonmicro.main>
 <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
 <1248269443.27058.1449.camel@twins>
 <alpine.LFD.2.00.0907221615480.2813@localhost.localdomain>
 <20090722143211.GB29404@rakim.wolfsonmicro.main>
 <alpine.LFD.2.00.0907221645240.2813@localhost.localdomain>
 <20090722145654.GA4987@rakim.wolfsonmicro.main>
 <alpine.LFD.2.00.0907221715260.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907221715260.2813@localhost.localdomain>
X-Cookie: User hostile.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 05:15:59PM +0200, Thomas Gleixner wrote:
> On Wed, 22 Jul 2009, Mark Brown wrote:

> > That's what they're all doing at present outside of genirq.

> They just are racy against disable/enable/request/free I guess :)

All of them are using a locks which means none of those can run at the
same time as an interrupt is being serviced.

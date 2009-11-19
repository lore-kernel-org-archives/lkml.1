Return-Path: <linux-kernel-owner+w=401wt.eu-S1751665AbZKSLVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbZKSLVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 06:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZKSLVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 06:21:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42643 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750773AbZKSLVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 06:21:02 -0500
Date: Thu, 19 Nov 2009 11:21:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       Magnus Damm <damm@opensource.se>, alsa-devel@alsa-project.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Null suspend/resume functions
Message-ID: <20091119112102.GF9763@rakim.wolfsonmicro.main>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com>
 <20091109105858.GB1245@sirena.org.uk>
 <20091109133136.GC1245@sirena.org.uk>
 <20091116153000.GB29479@sirena.org.uk>
 <20091117115236.GB1376@ucw.cz>
 <20091117124125.GD823@rakim.wolfsonmicro.main>
 <20091118160908.GD20887@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118160908.GD20887@elf.ucw.cz>
X-Cookie: Do you like "TENDER VITTLES"?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 05:09:08PM +0100, Pavel Machek wrote:
> On Tue 2009-11-17 12:41:25, Mark Brown wrote:

> > The problem I have with that is that for most APIs noop functions are a
> > big fat warning sign that something is going wrong and the API is being
> > abused.  This then creates noise and code review problems in the driver
> > code since you've got something that normally suggests a problem.

> That still sounds like poor reason to add tests to core. But return 0
> function for that purpose should be ok (and should make code easy to
> review, too).

What makes you believe that this is a poor reason?  The issue isn't that
the driver code is complex, the issue is that it's noise in the driver
which suggests that the driver isn't doing something it's supposed to
do.

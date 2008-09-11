Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbYIKKCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbYIKKCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYIKKCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:02:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50047 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751787AbYIKKCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:02:43 -0400
Date: Thu, 11 Sep 2008 11:02:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@kernel.org>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Core support for the WM8400 AudioPlus HiFi
	CODEC and PMU
Message-ID: <20080911100240.GA5718@rakim.wolfsonmicro.main>
Mail-Followup-To: Liam Girdwood <lrg@kernel.org>,
	Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org
References: <20080910182825.GB16721@rakim.wolfsonmicro.main> <1221071334-19381-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1221072422.17091.253.camel@odin> <20080910191335.GA26985@rakim.wolfsonmicro.main> <1221075484.17091.258.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221075484.17091.258.camel@odin>
X-Cookie: Not for human consumption.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 08:38:04PM +0100, Liam Girdwood wrote:
> On Wed, 2008-09-10 at 20:13 +0100, Mark Brown wrote:

> > Yeah, I considered doing that but decided that it was more trouble than
> > it was worth - the device has far fewer functions than the WM8350.

> Wouldn't splitting out audio from power at least half the size of the
> header. Imho probably making it easier to track down definitions per
> function.

It's a bit more than half the file for the audio stuff.  To be honest I
never found much problem - I tend to just search within the file to find
what I need.  I'll split out most of the audio definitions into a
separate header, though not quite all since some of the audio registers
are shared with other functionality.

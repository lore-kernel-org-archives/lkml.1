Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbZGRKry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbZGRKry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758157AbZGRKrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:47:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45443 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751771AbZGRKrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:47:51 -0400
Date: Sat, 18 Jul 2009 11:47:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: Add WM835x PMIC hardware  monitoring driver
Message-ID: <20090718104747.GA11121@opensource.wolfsonmicro.com>
References: <1247862795-22547-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20090718111712.78771b36@hyperion.delvare> <20090718095917.GA10160@opensource.wolfsonmicro.com> <20090718123951.34c776ca@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718123951.34c776ca@hyperion.delvare>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 12:39:51PM +0200, Jean Delvare wrote:
> On Sat, 18 Jul 2009 10:59:17 +0100, Mark Brown wrote:

> > The reason it's formatted like that is that the AUXADC input names match
> > the names of the supplies that are being monitored so the second parameter
> > is also used to provide a label to userspace.

> This isn't how I read the code. I see a look-up table for labels, so the
> macro implementation is just a detail which shouldn't matter.

Oh, yes, you're right.  Originally I'd implemented it the way I describe
but changed the code later - I'd forgotten that I'd done so when
replying to your mail.

I'll send a revised version out on Monday.

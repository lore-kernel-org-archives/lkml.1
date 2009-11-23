Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbZKWNLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbZKWNLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbZKWNLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:11:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46293 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757040AbZKWNLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:11:09 -0500
Date: Mon, 23 Nov 2009 13:11:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: mfd tree build failure
Message-ID: <20091123131113.GE24326@rakim.wolfsonmicro.main>
References: <20091123144103.73b4d64c.sfr@canb.auug.org.au>
 <20091123150346.e3948feb.sfr@canb.auug.org.au>
 <20091123122903.GB3616@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123122903.GB3616@sortiz.org>
X-Cookie: Avoid contact with eyes.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 01:29:04PM +0100, Samuel Ortiz wrote:

> True. Mark, I think we should get those symbols exported, unless you have a
> better idea ? Having wm831x as a boolean choice from Kconfig doesnt sound too
> god to me.

I don't see getting them exported flying, especially not in the
timeframe we've got for the merge window.  Keeping them non-exported has
been a deliberate decision on the part of the genirq maintainers.  I'll
send a patch making it built in.

Given the typical applications for these parts building the driver in
isn't the end of the world - there's a reasonable chance it'll be forced
built in for other reasons due to device-specific configuration.

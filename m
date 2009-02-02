Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbZBBLAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbZBBLAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZBBLAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:00:23 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1336 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZBBLAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:00:22 -0500
Date: Mon, 2 Feb 2009 11:00:17 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: Improve diagnostics for WM8350 ID register probe
Message-ID: <20090202110013.GA16510@sirena.org.uk>
References: <1232727516-5049-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1232727516-5049-2-git-send-email-broonie@opensource.wolfsonmicro.com> <1232727516-5049-3-git-send-email-broonie@opensource.wolfsonmicro.com> <20090130121009.6de9f11c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130121009.6de9f11c.akpm@linux-foundation.org>
X-Cookie: Goes (Went) over like a lead balloon.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 12:10:09PM -0800, Andrew Morton wrote:

> Reading a bunch of bytes into a u16 looks a bit fishy from the endianness
> point of view?

Hrm, yeah.  I'll send a patch for this.  Shouldn't be an issue in
practice since this is a primary PMIC and is unlikely to be used to
power anything with the wrong endianness.

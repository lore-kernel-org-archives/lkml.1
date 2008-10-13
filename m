Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYJMOXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYJMOXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbYJMOX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:23:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39683 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754289AbYJMOX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:23:28 -0400
Date: Mon, 13 Oct 2008 15:23:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Add placeholders for WM8350 client devices
Message-ID: <20081013142326.GA11689@rakim.wolfsonmicro.main>
References: <20081013113509.GA31973@rakim.wolfsonmicro.main> <1223897792-32031-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081013133707.GA4759@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013133707.GA4759@localdomain>
X-Cookie: Professional driver on closed track.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 03:37:08PM +0200, Samuel Ortiz wrote:

> > +struct wm8350_gpio {
> > +	struct platform_device *pdev;
> > +};
> I guess you're planning to add more stuff to those structures at some point ?

Yes - I'll the needed stuff along with the drivers to make the reviews a
bit clearer.  At the minute these structures are just placeholders to
avoid merge conflicts when the actual drivers are contributed.

Liam, I'll push out an updated version of this patch shortly which
removes the conditionals from the remove path.

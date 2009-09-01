Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZIANvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZIANvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZIANvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:51:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33507 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbZIANve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:51:34 -0400
Date: Tue, 1 Sep 2009 14:51:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] AB3100 regulator support v2
Message-ID: <20090901135123.GS19719@n2100.arm.linux.org.uk>
References: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com> <1251722641.4254.46.camel@finisterre.sirena.org.uk> <63386a3d0908310716x1a33a8fdpddedbaf24648216f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0908310716x1a33a8fdpddedbaf24648216f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 04:16:15PM +0200, Linus Walleij wrote:
> That said, I think the regulator paths are entirely in-kernel and
> under such circumstances that signals from userspace are blocked
> anyway.

Only if you explicitly block signals will pending signals be ignored
by the foo_interruptible() functions.

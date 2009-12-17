Return-Path: <linux-kernel-owner+w=401wt.eu-S1761759AbZLQT6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761759AbZLQT6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbZLQT6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:58:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39999 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbZLQT6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:58:33 -0500
Date: Thu, 17 Dec 2009 19:58:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Joe Buck <Joe.Buck@synopsys.COM>, "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>,
       Richard Guenther <richard.guenther@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091217195808.GE4440@n2100.arm.linux.org.uk>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com> <20091217181718.GA4440@n2100.arm.linux.org.uk> <20091217183517.GC10707@synopsys.com> <20091217190613.GB4440@n2100.arm.linux.org.uk> <20091217191401.GD10707@synopsys.com> <20091217193826.GE362@shareable.org> <20091217194837.GD4440@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217194837.GD4440@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 07:48:37PM +0000, Russell King - ARM Linux wrote:
> Given the lack of progress/bug reporting on ARM uclinux, the lack of
> platform support and the lack of configurations, my view is that there
> is no one actually using it.  I know that I don't particularly take any
> care with respect to uclinux when making changes to the MMU based kernels.
> Why bother if apparantly no one's using it?

Jamie,

As you seem to be a user of uclinux on ARM, could you help ensure that
the support there is bug fixed and we at least have a configuration file
which kautobuild can use to provide feedback on the build status of
uclinux on ARM please?

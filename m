Return-Path: <linux-kernel-owner+w=401wt.eu-S965348AbZLQTG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965348AbZLQTG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965338AbZLQTGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:06:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34385 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965293AbZLQTGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:06:46 -0500
Date: Thu, 17 Dec 2009 19:06:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Buck <Joe.Buck@synopsys.COM>
Cc: Richard Guenther <richard.guenther@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Jamie Lokier <jamie@shareable.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091217190613.GB4440@n2100.arm.linux.org.uk>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com> <20091217181718.GA4440@n2100.arm.linux.org.uk> <20091217183517.GC10707@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217183517.GC10707@synopsys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 10:35:17AM -0800, Joe Buck wrote:
> Besides, didn't I see a whole bunch of kernel security patches related
> to null pointer dereferences lately?  If page 0 can be mapped, you
> suddenly won't get your trap.

Page 0 can not be mapped on ARM kernels since the late 1990s, and this
protection is independent of the generic kernel.

Milage may vary on other architectures, but that's not a concern here.

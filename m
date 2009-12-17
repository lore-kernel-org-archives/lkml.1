Return-Path: <linux-kernel-owner+w=401wt.eu-S965361AbZLQTOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965361AbZLQTOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965327AbZLQTOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:14:16 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:58291 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965319AbZLQTOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:14:15 -0500
Date: Thu, 17 Dec 2009 11:14:01 -0800
From: Joe Buck <Joe.Buck@synopsys.COM>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Richard Guenther <richard.guenther@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Jamie Lokier <jamie@shareable.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091217191401.GD10707@synopsys.com>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com> <20091217181718.GA4440@n2100.arm.linux.org.uk> <20091217183517.GC10707@synopsys.com> <20091217190613.GB4440@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217190613.GB4440@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 11:06:13AM -0800, Russell King - ARM Linux wrote:
> On Thu, Dec 17, 2009 at 10:35:17AM -0800, Joe Buck wrote:
> > Besides, didn't I see a whole bunch of kernel security patches related
> > to null pointer dereferences lately?  If page 0 can be mapped, you
> > suddenly won't get your trap.
> 
> Page 0 can not be mapped on ARM kernels since the late 1990s, and this
> protection is independent of the generic kernel.
> 
> Milage may vary on other architectures, but that's not a concern here.

I don't understand, though, why you would want to implement a generally
useful facility (make the kernel trap so you can do a post-mortem
analysis) in a way that's only safe for the ARM port.

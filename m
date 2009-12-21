Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbZLUUMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbZLUUMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbZLUUMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:12:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55981 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZLUUMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:12:31 -0500
Date: Mon, 21 Dec 2009 20:10:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Henderson <rth@redhat.com>
Cc: Richard Guenther <richard.guenther@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Jamie Lokier <jamie@shareable.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091221201059.GD11669@n2100.arm.linux.org.uk>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com> <20091217181718.GA4440@n2100.arm.linux.org.uk> <4B2FCCE3.1090209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2FCCE3.1090209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 11:30:43AM -0800, Richard Henderson wrote:
> On 12/17/2009 10:17 AM, Russell King - ARM Linux wrote:
>> How is "size-optimal trap" defined?
>
> E.g. Sparc and MIPS have "tcc" instructions that trap based on the
> condition codes, and so we eliminate the branch.  That's the only
> optimization we apply with __builtin_trap.
>
>> Let me put it another way: I want this function to terminate with an
>> explicit NULL pointer dereference in every case.
>
> Then just use that.

That's precisely what we have been using for many years.

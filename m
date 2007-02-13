Return-Path: <linux-kernel-owner+w=401wt.eu-S965453AbXBMBOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965453AbXBMBOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 20:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965455AbXBMBOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 20:14:52 -0500
Received: from havoc.gtf.org ([69.61.125.42]:40993 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965453AbXBMBOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 20:14:52 -0500
Date: Mon, 12 Feb 2007 20:14:50 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Michael Clay <claym@osuosl.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: BusLogic check_region patch
Message-ID: <20070213011450.GA19511@havoc.gtf.org>
References: <20070213002704.GD9534@ash.osuosl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213002704.GD9534@ash.osuosl.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 04:27:04PM -0800, Michael Clay wrote:
> This patch is meant to remove the calls to check_region, a now
> deprecated function in order to get rid of compilation warning.  This
> was done by finding all calls to check_region and replacing them with
> calls to request_region.  check_region essentially was a wrapper around
> request_region, and was checking if the request_region returned a
> pointer or null.  As a result, I simply inlined the process of checking
> for null, eliminating the need to call the check_region wrapper.

Yes, but what happens when half the request_region() calls succeed, and
the other half fail?

You cannot simply substitute check_region with request_region.

	Jeff




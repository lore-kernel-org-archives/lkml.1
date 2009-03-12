Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZCLK4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZCLK4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbZCLK4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:56:22 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36539 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbZCLK4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:56:21 -0400
Subject: Re: [patch 2.6.29-rc7 regulator-next] regulator: refcount fixes
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
In-Reply-To: <200903111743.34708.david-b@pacbell.net>
References: <200903111743.34708.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 10:56:17 +0000
Message-Id: <1236855377.6781.202.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 16:43 -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Fix some refcounting issues in the regulator framework, supporting
> regulator_disable() for regulators that were enabled at boot time
> via machine constraints:
> 
>  - Update those regulators' usecounts after enabling, so they
>    can cleanly be disabled at that level.
> 
>  - Remove the problematic per-consumer usecount, so there's
>    only one level of enable/disable.
> 
> Buggy consumers could notice different bug symptoms.  The main
> example would be refcounting bugs; also, any (out-of-tree) users
> of the experimental regulator_set_optimum_mode() stuff which
> don't call it when they're done using a regulator.
> 
> This is a net minor codeshrink.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---

Applied.

Thanks

Liam


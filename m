Return-Path: <linux-kernel-owner+w=401wt.eu-S1762837AbZATUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762837AbZATUJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbZATUJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:09:12 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:39549 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923AbZATUJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:09:11 -0500
Subject: Re: [RFC] Regulator: Push lock out of _notifier_call_chain + add
 voltage change event.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4974C48A.1000103@cam.ac.uk>
References: <495FD46E.8040208@cam.ac.uk>
	 <1231065078.11643.116.camel@vega.slimlogic.co.uk>
	 <4973793D.60803@cam.ac.uk> <20090119152921.GA23444@rakim.wolfsonmicro.main>
	 <4974B107.6050701@gmail.com> <4974C182.1090902@cam.ac.uk>
	 <4974C48A.1000103@cam.ac.uk>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 20:09:07 +0000
Message-Id: <1232482147.16911.295.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 18:20 +0000, Jonathan Cameron wrote:
> From: Jonathan Cameron <jic23@cam.ac.uk>
> Regulator: Push lock out of _notifier_call_chain and into caller functions
> (side effect of fixing deadlock in regulator_force_disable)
> + Add a voltage changed event.
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> ---
> Follow up to Mark Brown's suggestion of moving the regulator lock out
> of the notifier code.  This avoids cases where it was previously necessary
> to unlock the regulator before notification occured.
> 
> Any scenarios where this will cause trouble?
> 
> I'll do a documentation patch when we've pinned down how to do this.
> + can break the patch into one for pushing the lock out and one for
> adding the event.
> 
>  drivers/regulator/core.c             |   15 ++++++++++-----
>  drivers/regulator/wm8350-regulator.c |    2 ++
>  drivers/regulator/wm8400-regulator.c |    2 +-
>  include/linux/regulator/consumer.h   |    2 ++
>  4 files changed, 15 insertions(+), 6 deletions(-)
> 

Applied and fixed trailing white space.

Thanks

Liam


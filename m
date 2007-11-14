Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbXKNLND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbXKNLND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:13:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXKNLMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:12:53 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:15728 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXKNLMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:12:52 -0500
Subject: Re: [PATCH] module loader should not complain about unknown symbol
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       Andi Kleen <andi@firstfloor.org>, Jon Masters <jonathan@jonmasters.org>,
       Martin Schwidefksy <schwidefsky@de.ibm.com>
In-Reply-To: <200711131352.23244.rusty@rustcorp.com.au>
References: <1194877107.5656.31.camel@localhost.localdomain>
	 <200711130923.12616.rusty@rustcorp.com.au>
	 <200711131352.23244.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 12:12:35 +0000
Message-Id: <1195042355.5167.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-13 at 13:52 +1100, Rusty Russell wrote: 
> On Tuesday 13 November 2007 09:23:12 Rusty Russell wrote:
> > Better might be to put in a waitqueue and wake it up whenever a module is
> > deleted or changes status.  Then use_module() can wait if
> > strong_try_module_get() returns -EBUSY (up to 30 seconds, then print a
> > warning and fail).
> 
> And here it is.  Does it work for you Jan?

No, it hangs at boot time after starting udev. All CPUs are in
cpu_idle(). Unfortunately I've had no time for further debugging and
I'll be offline for the next 10 days...

-jang


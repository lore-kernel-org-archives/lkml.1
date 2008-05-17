Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbYEQEzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbYEQEzc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 00:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYEQEzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 00:55:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:19229 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYEQEzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 00:55:21 -0400
Message-ID: <a24804730805162155m72e6b40aweb8822515c880c50@mail.gmail.com>
Date: Fri, 16 May 2008 21:55:20 -0700
From: "Chris Peterson" <cpeterso@cpeterso.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Jeff Garzik" <jeff@garzik.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Rick Jones" <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080516191125.46f59ad6@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>
	 <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com>
	 <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com>
	 <482C8D4D.3040702@garzik.org>
	 <20080516132107.GA11304@csclub.uwaterloo.ca>
	 <20080516161029.44ded734@core>
	 <20080516173610.GA27126@csclub.uwaterloo.ca>
	 <20080516191125.46f59ad6@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If they don't need that level of security they can use /dev/urandom.
> Piping network randomness into /dev/urandom is probably quite sensible
> but not into /dev/random.

If there was an IRQF_SAMPLE_DUBIOUS or IRQF_SAMPLE_URANDOM for network
device IRQs to feed /dev/urandom, are there any other IRQs that should
use it instead of IRQF_SAMPLE_RANDOM?

>From a cursory search, it seems like:

* network drivers could use IRQF_SAMPLE_URANDOM
* all (?) other device drivers could use IRQF_SAMPLE_RANDOM
* and timer IRQs should not use either?


chris

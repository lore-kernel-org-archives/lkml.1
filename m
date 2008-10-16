Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYJPRNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYJPRNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYJPRMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:12:52 -0400
Received: from willie.n0ano.com ([64.66.241.76]:41318 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751507AbYJPRMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:12:51 -0400
From: n0ano@n0ano.com
Date: Thu, 16 Oct 2008 11:12:18 -0600
To: Yinghai Lu <yinghai@kernel.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, n0ano@n0ano.com,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081016171218.GD14490@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com> <20081014233031.GB14490@xolotl.n0ano.com> <1224061999.25929.7.camel@test.thuisdomein> <20081015204850.GC14490@xolotl.n0ano.com> <1224153822.3587.23.camel@test.thuisdomein> <48F76A8B.6050306@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F76A8B.6050306@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 09:23:39AM -0700, Yinghai Lu wrote:
>... 
> earlycon= and conole= share uart[8250]...
> 
> the difference console= will start from early console and switch normal console automatically if the ttyS come out with same io/mmio address etc.
> 

But there is no advantage to `earlycon' given that you can accomplish
the same thing with `console'.  The only use that I can see is if
you specify `earlycon' without specifying `console' and then all
you get are the initial kernel messages, after the serial drivers
intializes all further messages go to the VGA.  If makes much more
sense to me to just use the `console' parameter to get all kernel
messages on the serial port, and then there is no need for
`earlycon'.

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786

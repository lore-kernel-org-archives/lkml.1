Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYJQQFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYJQQFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbYJQQFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:05:44 -0400
Received: from willie.n0ano.com ([64.66.241.76]:41839 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754670AbYJQQFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:05:43 -0400
From: n0ano@n0ano.com
Date: Fri, 17 Oct 2008 10:05:27 -0600
To: Yinghai Lu <yinghai@kernel.org>
Cc: n0ano@n0ano.com, Paul Bolle <pebolle@tiscali.nl>,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081017160527.GI14490@xolotl.n0ano.com>
References: <1224061999.25929.7.camel@test.thuisdomein> <20081015204850.GC14490@xolotl.n0ano.com> <1224153822.3587.23.camel@test.thuisdomein> <48F76A8B.6050306@kernel.org> <20081016171218.GD14490@xolotl.n0ano.com> <48F785B0.7000008@kernel.org> <20081016182556.GE14490@xolotl.n0ano.com> <86802c440810161130x304128faj6b1a1a6e1b90ed03@mail.gmail.com> <20081017024544.GB9378@xolotl.n0ano.com> <86802c440810162032i25d7af9dk6fb8782b534e16d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810162032i25d7af9dk6fb8782b534e16d1@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 08:32:53PM -0700, Yinghai Lu wrote:
>... 
> you want to remove earlycon from Documenatation/kernel-parameters.txt?
> 
> YH

I want to remove the documentation and also remove the code
associated with the earlycon `parameter`.  I absolutely want
to keep the early printk capability but that should be
controlled by the `console' parameter, there's no need for
a separate `earlycon' parameter.

I am against code bloat and putting extra code in the kernel
to support unneeded parameters is just a waste.

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786

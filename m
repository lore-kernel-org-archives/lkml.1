Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbYJQCj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbYJQCj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 22:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYJQCjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 22:39:18 -0400
Received: from willie.n0ano.com ([64.66.241.76]:47403 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752074AbYJQCjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 22:39:18 -0400
From: n0ano@n0ano.com
Date: Thu, 16 Oct 2008 20:39:12 -0600
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: donald.d.dugger@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081017023912.GA9378@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com> <200810161716.47620.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810161716.47620.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 05:16:47PM -0600, Bjorn Helgaas wrote:
>... 
> Did you play with "console=uart,io,0xe880,115200n8" at all?
> 
> That gives you early serial console output and automatically switches
> to the matching ttyS device when it is discovered.
> 
> "console=uart" doesn't have support for crystal frequency, but that
> could be added in drivers/serial/8250_early.c.
> 

Yep, that was pointed out and my latest patch does just that, use the
`uart' syntax to specify I/O address and enhance it to control crystal
frequency.

We're arguing now about what to do about the `earlycon' and `earlyprintk'
parameters, I contend we should remove those as the `console=uart' is
a superset of their capabilities but there are some dissenting opinions.

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786

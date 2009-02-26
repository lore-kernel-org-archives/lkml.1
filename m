Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZBZThm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZBZThm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbZBZThE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:37:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:55477 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbZBZThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:37:01 -0500
Subject: Re: Linux 2.6.29-rc6
From: David Woodhouse <dwmw2@infradead.org>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Olsen <dolsen@lnxi.com>, Ryan Jackson <rjackson@lnxi.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <49A6EE17.4070102@krogh.cc>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A679E8.1010301@krogh.cc>
	 <alpine.LFD.2.00.0902260941090.3111@localhost.localdomain>
	 <49A6EE17.4070102@krogh.cc>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 04:36:48 +0900
Message-Id: <1235677008.8730.176.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 19:31 +0000, Jesper Krogh wrote:
> 1) pick the distro .config
> 2) make oldconfig

So it should have been a module, not built-in?

> 3) Let the kernel load what it think it needs.

That part at least ought to be disabled -- we don't let this driver
autoload, because unless you _know_ you need it, you don't need it.

It's for overwriting your BIOS.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


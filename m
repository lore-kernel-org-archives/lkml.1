Return-Path: <linux-kernel-owner+w=401wt.eu-S966276AbXDDCEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966276AbXDDCEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966278AbXDDCED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:04:03 -0400
Received: from ozlabs.org ([203.10.76.45]:43676 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966276AbXDDCEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:04:02 -0400
Subject: Re: [patch 4/6] Rename the parainstructions symbols to be
	consistent with the others
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070404011453.598418421@goop.org>
References: <20070404010655.400913479@goop.org>
	 <20070404011453.598418421@goop.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 12:03:17 +1000
Message-Id: <1175652197.12230.563.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 18:06 -0700, Jeremy Fitzhardinge wrote:
> plain text document attachment (fix-parainstructions-name.patch)
> The other symbols used to delineate the alt-instructions sections have
> the form __foo/__foo_end.  Rename parainstructions to match.

OK, I guess this is an area where the kernel has its own standard.

(__start_<secname> and __stop_<secname> are the symbols automatically
inserted by ld if the section name is straight alpha-numeric.  It's
actually pretty cool for code where you want section boundaries without
writing a linker script).

Cheers,
Rusty.



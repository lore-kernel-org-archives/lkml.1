Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0BTLJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 06:09:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:56869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab0BTLJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 06:09:30 -0500
Subject: Re: Firmware versioning best practices II
From: David Woodhouse <dwmw2@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Vipin Mehta <Vipin.Mehta@atheros.com>
In-Reply-To: <1266663639.10357.1.camel@jlt3.sipsolutions.net>
References: <43e72e891002191823h3245bc0cn7a8745ae77409aa8@mail.gmail.com>
	 <1266662106.1820.4034.camel@macbook.infradead.org>
	 <1266663639.10357.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 11:09:26 +0000
Message-ID: <1266664166.1820.4165.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 12:00 +0100, Johannes Berg wrote:
> That doesn't make much sense anyway. If the firmware filename is
> foo-$APIVER-$CODEVER every code change would need a corresponding driver
> change. If it is just foo-$APIVER then the $CODEVER can be embedded in
> the firmware file and printed so you know which code you're using, but
> if it doesn't influence the API I don't see why it should be part of the
> filename? 

The idea is that just like with shared libraries, you have a symlink
from the 'soname' foo-3.fw to the actual file foo-3-1.4.1.fw.

For shared libraries, it's easy to create those symlinks automatically
using ldconfig. For firmware that doesn't really work though -- since
the soname isn't encoded in the file like it is in ELF libraries.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


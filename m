Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbZKXJET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbZKXJET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932342AbZKXJES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:04:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:33595 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbZKXJEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:04:16 -0500
Subject: Re: Where to report firmware bugs
From: David Woodhouse <dwmw2@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Samir Gadkari <Samir.Gadkari@atheros.com>,
       Vikram Kandukuri <Vikram.Kandukuri@atheros.com>
In-Reply-To: <43e72e890911230941m29394bcapcff95de9391637a3@mail.gmail.com>
References: <43e72e890911230941m29394bcapcff95de9391637a3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 09:04:14 +0000
Message-ID: <1259053454.29729.272.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 09:41 -0800, Luis R. Rodriguez wrote:
> We now have open firmware for at least one wireless device upstream,
> the ar9170 device firmware [1]. Granted no specific point releases
> have been made yet but it should be possible in the future to do so.
> I'd also like to see more open firmware in the future. I also just
> reviewed some simple driver for our bluetooth devices, the ath3k
> driver and it seems clear to me in these cases that firmware will do
> everything and chances are the actual driver won't have much bugs.
> 
> So -- for the cases of open firmware, or in cases where we have
> firmware where it does most of the job of supporting the device where
> should we send users to report bugs to? The kernel bugzilla at least
> does not seem to have a section for firmware? Should it?
> 
> In the case of iwl3945 it seems users report bugs directly on the
> kernel.org and refer the driver directly, we'll follow that for now,
> but for cases where the firmware *is* the issue it would seem easier
> to be able to search for issues specifically for firmware.

Well, Intel wireless also has its own bugzilla. Although perhaps it's
quite a bad example because the firmware bugs are just too opaque and
don't seem to get fixed. Bug #2037 is an example. It would benefit from
opening up the firmware too, so that we can actually debug and fix it.

I'm not entirely sure it's a good idea to use kernel.org bugzilla for
firmware bugs. Each firmware is its own individual project, and should
have its own bug tracking system.

On the other hand, it doesn't cost us much to add a firmware section to
bugzilla, and it reduces the amount of infrastructure that people need
to provide when they open up their firmware -- so maybe it make sense.
We want to encourage people to open up as much as possible, after all.

-- 
dwmw2


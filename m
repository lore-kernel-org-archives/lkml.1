Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbYIVW2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbYIVW2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbYIVW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:28:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54059
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754388AbYIVW21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:28:27 -0400
Date: Mon, 22 Sep 2008 15:28:15 -0700 (PDT)
Message-Id: <20080922.152815.22060684.davem@davemloft.net>
To: jkosina@suse.cz
Cc: airlied@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com, david.vrabel@csr.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0809230010460.27884@twin.jikos.cz>
References: <20080921.165159.67476441.davem@davemloft.net>
	<21d7e9970809212359y6876c405ub57dca3e9ee737e4@mail.gmail.com>
	<Pine.LNX.4.64.0809230010460.27884@twin.jikos.cz>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Tue, 23 Sep 2008 00:15:08 +0200 (CEST)

> On Mon, 22 Sep 2008, Dave Airlie wrote:
> 
> > Sep 8th I booted my own 2.6.27-rc5 kernel based from
> > ec0c15afb41fd9ad45b53468b60db50170e22346
> > This got a corrupted e1000e checksum and every kernel since has.
> 
> Have you restored the EEPROM contents after it got corrupted for the first 
> time?
> 
> Once the EEPROM contents get corrupted, the card will then be broken
> forever even on kernel that gets this fixed one day. 
> 
> This is pretty serious bug in fact, as it renders hardware of poor users 
> unusable, and just patching kernel is then not enough to put things back 
> to shape.

The top priority is to root cause this, so that we can stop the
problem from happening as fast as possible, and I'm still waiting for
the SHA1 ID that was used for the last kernel Dave booted before the
problem occurred which is pretty damn critical for making forward
progress here.

It could even be some PCI or x86 layer change that caused the corruption,
we don't even know yet.

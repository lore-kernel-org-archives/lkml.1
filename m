Return-Path: <linux-kernel-owner+w=401wt.eu-S1763649AbXHXJN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763649AbXHXJN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 05:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbXHXJNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 05:13:19 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:54151 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbXHXJNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 05:13:18 -0400
Date: Fri, 24 Aug 2007 11:03:18 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: john stultz <johnstul@us.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
Message-ID: <20070824110318.5fc6cdce@localhost>
In-Reply-To: <1187903135.6024.18.camel@localhost.localdomain>
References: <20070823222115.122a37ca@localhost>
	<617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
	<1187903135.6024.18.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 14:05:35 -0700
john stultz <johnstul@us.ibm.com> wrote:

> Also I'm not quite sure I see where the hard
> freeze is coming from.

Using plain 2.6.23-rc3-g1a8f4610 and "nmi_watchdog=1" I've managed to
capture a Kernel Panic (about 40 seconds after switching to hpet as
clocksource):

http://img170.imageshack.us/img170/1552/2hpetoopshw9.jpg

it's stuck in "update_wall_time()".

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g1a8f4610-dirty on x86_64

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZGJPvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZGJPvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZGJPuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:50:44 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:50849 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZGJPum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:50:42 -0400
Subject: Re: [PATCH] reduce export symbol CRC table size on 64-bit archs
From: Jon Masters <jonathan@jonmasters.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Michal Marek <mmarek@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, tony.luck@intel.com,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
       hpa@zytor.com
In-Reply-To: <4A57089B0200007800009C0E@vpn.id2.novell.com>
References: <4A4A18780200007800008345@vpn.id2.novell.com>
	 <4A4E671C.2090201@suse.cz> <4A51C71B0200007800008EE2@vpn.id2.novell.com>
	 <200907092044.22108.rusty@rustcorp.com.au>
	 <4A57089B0200007800009C0E@vpn.id2.novell.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 10 Jul 2009 11:50:01 -0400
Message-Id: <1247241001.5006.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 08:23 +0100, Jan Beulich wrote:

> Actually I meanwhile think that module-init-tools can easily detect the changed
> layout without any further kernel side adjustments: Since it is known that a
> CRC always is a 32-bit value, simply checking whether the so-far-used 64-bit
> value has more than 32 significant bits should suffice: If so, the new layout
> is being used (with the symbol name starting at offset 4), else the old one is
> in effect (name at offset 8). This ought to be a pretty trivial change to that
> code.

Agreed. That can be done. I won't get chance to do that until Sunday
though because I'm about to be on a plane back from Tokyo to Boston and
I expect a day of living hell with jetlag/email craziness.

Jon.



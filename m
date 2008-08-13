Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYHNLEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYHNLEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 07:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYHNLEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 07:04:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1258 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752683AbYHNLEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 07:04:45 -0400
Date: Wed, 13 Aug 2008 21:22:48 +0200
From: Pavel Machek <pavel@suse.cz>
To: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature shutdowns
Message-ID: <20080813192247.GF6995@ucw.cz>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807261434380.2958@localhost.localdomain> <alpine.LFD.1.10.0808011701500.3011@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808011701500.3011@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I ACK Thomas' suggestion to check for <= 0C for HOT,
> PSV and ACx trip points.  While we don't have such a

Hmm, I don't think that's good idea. 0Celsius is not special value.

While having _CRT below 25Celsius would be quite strange (machine
that can not run on room temperature?), I could imagine it (cryogenic
cooling, cpu is overclocked, needs -10C to work).

Machine with AC0 == -10C is very easy to imagine, OTOH. It is normal
notebook that needs fans during normal temperatures, but does not need
it if it is really cold.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

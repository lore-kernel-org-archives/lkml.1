Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbXCTLmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbXCTLmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXCTLmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:42:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbXCTLmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:42:01 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far
Date: Tue, 20 Mar 2007 12:41:46 +0100
User-Agent: KMail/1.9.1
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       Len Brown <lenb@kernel.org>, tglx@linutronix.de,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
References: <200703161230.03712.maximlevitsky@gmail.com> <20070320042734.GA9700@kroah.com> <20070320113644.GA7751@one.firstfloor.org>
In-Reply-To: <20070320113644.GA7751@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703201241.47920.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 20. März 2007 12:36 schrieb Andi Kleen:
> It's long after timer calibration, which is what it interfered with here.
> 
> To handle that it would need to be moved to the x86 early quirks and
> use boot_ioremap etc. It would be probably somewhat messy, but doable.

USB is not specific to x86. And not necessarily the only user of SMM.
Is this really necessary?

	Regards
		Oliver

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZBCEV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZBCEV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZBCEVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:21:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:39479 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZBCEVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:21:50 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902022008060.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902022239.02453.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
	 <200902022331.49131.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain>
	 <1233633061.16867.41.camel@pasglop> <1233633315.16867.45.camel@pasglop>
	 <alpine.LFD.2.00.0902022008060.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 15:21:18 +1100
Message-Id: <1233634878.16867.50.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 20:09 -0800, Linus Torvalds wrote:
> 
> On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> > 
> > The new code will basically make the core bring back everything to D0 on
> > resume. That's a huge power surge and often not needed at all...
> 
> Well, we could easily do it only if it was D0 _before_ resume.
> 
> But quite frankly, before I worry about "huge power surge" issues, I want 
> to feel like the architecture allows for clueless driver writers, and 
> still giving us reliable suspend/resume.
> 
> Once we have that reliability, and only _then_, do I care at all about 
> power issues. Make it work first, and not result in a dead machine if 
> there is unlucky shared interrupt timings.

Right.

Ben.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbYAOTk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbYAOTk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYAOTkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:40:49 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35320 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYAOTks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:40:48 -0500
Date: Tue, 15 Jan 2008 12:40:46 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Camuso <tcamuso@redhat.com>, Greg KH <greg@kroah.com>,
       Loic Prylli <loic@myri.com>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080115194046.GG18741@parisc-linux.org>
References: <1200208085.6896.134.camel@pasglop> <20080113072415.GB18741@parisc-linux.org> <20080113090108.3224698c@laptopd505.fenrus.org> <20080114225225.GQ18741@parisc-linux.org> <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <478D0928.9020802@redhat.com> <alpine.LFD.1.00.0801151137390.2806@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801151137390.2806@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 11:38:42AM -0800, Linus Torvalds wrote:
> On Tue, 15 Jan 2008, Tony Camuso wrote:
> > Linus is confident that conf1 is not going away for at least the
> > next five years.
> 
> Not on PC's. Small birds tell me that there can be all these non-PC x86 
> subarchitectures that may or may not have conf1.

Right -- hence my patch on top of Ivan's which removes all the assumptions
about conf1 from mmconfig (there are still *references* to conf1 in the
mmconfig code, but they'll only be used if conf1 is functional).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

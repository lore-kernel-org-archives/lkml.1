Return-Path: <linux-kernel-owner+w=401wt.eu-S933117AbYA2OQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117AbYA2OQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763072AbYA2OQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:16:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762586AbYA2OQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:16:06 -0500
Message-ID: <479F34E6.40806@redhat.com>
Date: Tue, 29 Jan 2008 09:15:02 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <20080114225225.GQ18741@parisc-linux.org> <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128190505.5f5b1ccc@laptopd505.fenrus.org> <20080129031804.GF20198@parisc-linux.org> <20080129131955.GC10761@kroah.com>
In-Reply-To: <20080129131955.GC10761@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jan 28, 2008 at 08:18:04PM -0700, Matthew Wilcox wrote:
>> I'm more optimistic because we've so severely restricted the use of
>> mmconf after these patches that it's unlikely to cause problems.  I also
>> hear Vista is now using mmconf, so fewer implementations are going to
>> be buggy at this point.
> 
> Hahahaha, oh, that's a good one...
> 
> But what about the thousands of implementations out there that are
> buggy?
> 
> I'm with Arjan here, I'm very skeptical.
> 
> Matthew, with Arjan's patch, is anything that currently works now
> broken?  Why do you feel it is somehow "wrong"?
> 
> thanks,
> 
> greg k-h

Greg,

The problem with Arjan's patch, if I understand it correctly, is that it
requires drivers to make a call to access extended PCI config space.

And, IIRC, Arjan's patch encumbers drivers for all arch's, even those
that have no MMCONFIG problems.

The patches proposed by Loic, Ivan, Matthew, and myself, all address the
problem in an x86-specific manner that is transparent to the drivers.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751362AbYAMGnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbYAMGnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 01:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbYAMGni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 01:43:38 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51398 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYAMGnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 01:43:37 -0500
Message-ID: <4789B2F8.5010800@garzik.org>
Date: Sun, 13 Jan 2008 01:43:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Arjan van de Ven <arjan@infradead.org>, tcamuso@redhat.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <20080112094557.71f5382a@laptopd505.fenrus.org> <20080112214911.GA20102@jurassic.park.msu.ru> <20080112150120.05f93768@laptopd505.fenrus.org> <47895767.3090503@redhat.com> <20080112164006.6f6f7bc2@laptopd505.fenrus.org> <47896B3B.2000108@redhat.com> <20080112204248.29abb1dd@laptopd505.fenrus.org> <20080113044748.GY18741@parisc-linux.org>
In-Reply-To: <20080113044748.GY18741@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, Jan 12, 2008 at 08:42:48PM -0800, Arjan van de Ven wrote:
>> Wanne bet there'll be devices that screw this up? THere's devices that even screwed
>> up the 64-256 region after all.
> 
> I don't know if they 'screwed it up'.  There are devices that misbehave
> when registers are read from pci config space.  But this was never
> guaranteed to be a safe thing to do; it gradualy became clear that
> people expected to be able to read random registers and manufacturers
> responded accordingly, but I don't think you were ever guaranteed to be
> able to peek at bits of config space arbitrarily.

Quite correct...  Reading registers can have all sorts of side effects, 
for example clearing chip conditions.

	Jeff




Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYAMEr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYAMEr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 23:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYAMErv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 23:47:51 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:38716 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYAMEru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 23:47:50 -0500
Date: Sat, 12 Jan 2008 21:47:48 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: tcamuso@redhat.com, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080113044748.GY18741@parisc-linux.org>
References: <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <20080112094557.71f5382a@laptopd505.fenrus.org> <20080112214911.GA20102@jurassic.park.msu.ru> <20080112150120.05f93768@laptopd505.fenrus.org> <47895767.3090503@redhat.com> <20080112164006.6f6f7bc2@laptopd505.fenrus.org> <47896B3B.2000108@redhat.com> <20080112204248.29abb1dd@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112204248.29abb1dd@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 08:42:48PM -0800, Arjan van de Ven wrote:
> Wanne bet there'll be devices that screw this up? THere's devices that even screwed
> up the 64-256 region after all.

I don't know if they 'screwed it up'.  There are devices that misbehave
when registers are read from pci config space.  But this was never
guaranteed to be a safe thing to do; it gradualy became clear that
people expected to be able to read random registers and manufacturers
responded accordingly, but I don't think you were ever guaranteed to be
able to peek at bits of config space arbitrarily.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYGHW0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYGHW0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYGHW0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:26:35 -0400
Received: from xenotime.net ([66.160.160.81]:59696 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751065AbYGHW0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:26:34 -0400
Date: Tue, 8 Jul 2008 15:26:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: Pavel Machek <pavel@suse.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-Id: <20080708152631.715092c5.rdunlap@xenotime.net>
In-Reply-To: <CF70AA892F109448AEA269483B3A983903BB8CF552@G1W1215.americas.hpqcorp.net>
References: <20080623160052.GA7616@ldl.fc.hp.com>
	<20080627191458.GA10872@ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
	<20080707160658.GB1794@elf.ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
	<20080708072152.GD1761@elf.ucw.cz>
	<20080708073818.GA14245@elf.ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CEFC4@G1W1215.americas.hpqcorp.net>
	<20080708215002.GA18195@elf.ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CF552@G1W1215.americas.hpqcorp.net>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008 22:19:18 +0000 Altobelli, David wrote:

> Pavel Machek wrote:
> > Could you provide the list of commands (at least) so we can be more
> > concrete?
> 
> Unfortunately, I don't believe that I can.  We reviewed this internally,
> and the question of documentation was raised.  The hardware teams did
> not approve disseminating the ABI.  To be clear, we understand what we
> are doing by releasing the driver as GPLv2, the actual functionality
> of communicating with iLO was okayed for release.  But releasing the
> specifics of what we can send was not approved.

Can you at least point people to the user manual etc. so they can see
what commands/functionality are/is available?


> > Yes, I believe we do want to have 30 commands it kernel, because it
> > will allow same userland to work on HP machines, AMD machines, etc...
> 
> We sell AMD :)
> 
> > (I assume management processors have pretty similar functionality
> > accross vendors, right?)
> 
> I can't speak for other vendors.
> 
> >> It seems much cleaner to keep the kernel interface simple and opaque
> >> (ie read/write), and handle the details of the commands in user
> >> space. From my limited understanding, I thought that was a common
> >> goal here: move what you can to userspace.
> >
> > We are not _that_ extreme. Yes, keep stuff in userspace is important,
> > but "hide hardware differences" is more important goal.
> 
> That seems like a larger question/goal.  Giving users some consistent
> interfaces to do stuff would be nice, but I'd really like to handle this
> driver on its own.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbXEGEXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbXEGEXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 00:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbXEGEXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 00:23:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:37062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbXEGEXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 00:23:23 -0400
From: Neil Brown <neilb@suse.de>
To: Greg KH <greg@kroah.com>
Date: Mon, 7 May 2007 14:22:58 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17982.43426.945725.747958@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SCSI discover order strangeness [Bug 8412] New:
	CONFIG_MOUSE_PS2 makes RAID detection fail
In-Reply-To: message from Greg KH on Tuesday May 1
References: <200705010918.l419IC8B016596@fire-2.osdl.org>
	<17975.3196.435174.722895@notabene.brown>
	<20070502033102.GA7890@kroah.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday May 1, greg@kroah.com wrote:
> On Tue, May 01, 2007 at 07:46:36PM +1000, Neil Brown wrote:
> > 
> > My first thought was that the new threaded device discovery was
> > allowing md init to happen before scsi discovery was complete.  Maybe
> > the presence of CONFIG_MOUSE_PS2 makes some bit go faster...
> > 
> > However 
> >   # CONFIG_SCSI_SCAN_ASYNC is not set
> > 
> > so maybe not...
> > 
> > Greg (or anyone else reading): you know about this threaded
> > discovery.. could it allow some discovery to complete after userspace
> > has started, and does CONFIG_SCSI_SCAN_ASYNC affect it?
> 
> This kind of threaded discovery is different from the bus-level threaded
> probing that I originally proposed a while back, and then later
> retracted due to bugs.
> 
> So this is just a scsi thing, I know nothing about it.
> 

OK, thanks.  It turns out they are USB drives, so maybe it is a USB
problem, or maybe their expectations are wrong.

It also turns out that the email->bugzilla gateway completely failed
for me in trying to deal with this bug.  Ho hum.

NeilBrown

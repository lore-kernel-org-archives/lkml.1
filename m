Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXFVLez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXFVLez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbXFVLeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:34:44 -0400
Received: from mx1.suse.de ([195.135.220.2]:56833 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbXFVLel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:34:41 -0400
From: Neil Brown <neilb@suse.de>
To: Stephen Smalley <sds@tycho.nsa.gov>
Date: Fri, 22 Jun 2007 21:34:30 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18043.46022.98869.640499@notabene.brown>
Cc: Lars Marowsky-Bree <lmb@suse.de>, James Morris <jmorris@namei.org>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
In-Reply-To: message from Stephen Smalley on Friday June 22
References: <20070615200623.GA2616@elf.ucw.cz>
	<20070615211157.GB7337@kroah.com>
	<46732124.80509@novell.com>
	<20070616000251.GG2616@elf.ucw.cz>
	<20070621160840.GA20105@marowsky-bree.de>
	<20070621183311.GC18990@elf.ucw.cz>
	<20070621192407.GF20105@marowsky-bree.de>
	<Line.LNX.4.64.0706211530290.483@localhost.localdomain>
	<20070621195400.GK20105@marowsky-bree.de>
	<1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
	<20070621211743.GN20105@marowsky-bree.de>
	<1182511179.24664.1.camel@moss-spartans.epoch.ncsc.mil>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday June 22, sds@tycho.nsa.gov wrote:
> > 
> > Yes. Your use case is different than mine.
> 
> My use case is being able to protect data reliably.  Yours?

Saying "protect data" is nearly meaningless without a threat model.
I bet you don't try to protect data from a direct nuclear hit, or a
court order.


AA has a fairly clear threat model.  It involves a flaw in a
program being used by an external agent to cause it to use
privileges it would not normally exercise to subvert privacy or
integrity.
I think this model matches a lot of real threats that real sysadmins
have real concerns about.  I believe that the design of AA addresses
this model quite well. 

What is your threat model?  Maybe it is just different.

NeilBrown

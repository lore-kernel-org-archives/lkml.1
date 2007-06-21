Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbXFUUVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbXFUUVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXFUUVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:21:45 -0400
Received: from gate.in-addr.de ([212.8.193.158]:48382 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752070AbXFUUVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:21:44 -0400
Date: Thu, 21 Jun 2007 22:21:07 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070621202107.GM20105@marowsky-bree.de>
References: <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <20070621200740.GG18990@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070621200740.GG18990@elf.ucw.cz>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-21T22:07:40, Pavel Machek <pavel@ucw.cz> wrote:

> > AA is supposed to allow valid access patterns, so for non-buggy apps +
> > policies, the rename will be fine and does not change the (observed)
> > permissions.
> That still breaks POSIX, right? Hopefully it will not break any apps,
> but...

No, it does not break POSIX.

Unless, of course, there's a bug in the policy or in the program. Bugs
are generally not covered by POSIX, for some strange reason.

(The argument that POSIX codifies implementation bugs in Unix(tm)
implementations of the time non-withstanding.)

> > A veto is not a technical argument. All technical arguments (except for
> > "path name is ugly, yuk yuk!") have been addressed, have they not?
> There still is "it does not work with long pathnames".
> 
> Plus IIRC we have something like "AA has to allocate path-sized
> buffers along every syscall".

That is an implementation bug though. I'm sure we have other bugs in the
kernel too - this isn't a design flaw. 

(If people are allowed to thinair solutions for implementing AA on top
of SELinux, I can thinair that this can be solved by reverse-matching
the dentry tree against the policy as the path is traversed and
constructed, requiring a constant sized buffer.)



Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde


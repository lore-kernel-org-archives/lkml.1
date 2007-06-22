Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbXFVLtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbXFVLtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXFVLtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:49:08 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:33419 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752704AbXFVLtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:49:05 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Neil Brown <neilb@suse.de>
Cc: Lars Marowsky-Bree <lmb@suse.de>, James Morris <jmorris@namei.org>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <18043.46022.98869.640499@notabene.brown>
References: <20070615200623.GA2616@elf.ucw.cz>
	 <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com>
	 <20070616000251.GG2616@elf.ucw.cz>
	 <20070621160840.GA20105@marowsky-bree.de>
	 <20070621183311.GC18990@elf.ucw.cz>
	 <20070621192407.GF20105@marowsky-bree.de>
	 <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
	 <20070621195400.GK20105@marowsky-bree.de>
	 <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
	 <20070621211743.GN20105@marowsky-bree.de>
	 <1182511179.24664.1.camel@moss-spartans.epoch.ncsc.mil>
	 <18043.46022.98869.640499@notabene.brown>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 22 Jun 2007 07:48:58 -0400
Message-Id: <1182512938.24664.19.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 21:34 +1000, Neil Brown wrote:
> On Friday June 22, sds@tycho.nsa.gov wrote:
> > > 
> > > Yes. Your use case is different than mine.
> > 
> > My use case is being able to protect data reliably.  Yours?
> 
> Saying "protect data" is nearly meaningless without a threat model.
> I bet you don't try to protect data from a direct nuclear hit, or a
> court order.
> 
> 
> AA has a fairly clear threat model.  It involves a flaw in a
> program being used by an external agent to cause it to use
> privileges it would not normally exercise to subvert privacy or
> integrity.
> I think this model matches a lot of real threats that real sysadmins
> have real concerns about.  I believe that the design of AA addresses
> this model quite well.
>  
> 
> What is your threat model?  Maybe it is just different.

The threat "model" you describe above is a subset of what SELinux
addresses.  And our argument is that AA does not meet that model well,
because it relies upon ambiguous and unstable identifiers for subjects
and objects (a violation of the fundamental requirements for access
control) and because it provides very incomplete mediation.

>From http://www.nsa.gov/selinux/info/faq.cfm:
The Security-enhanced Linux's new features are designed to enforce the
separation of information based on confidentiality and integrity
requirements. They are designed for preventing processes from reading
data and programs, tampering with data and programs, bypassing
application security mechanisms, executing untrustworthy programs, or
interfering with other processes in violation of the system security
policy. They also help to confine the potential damage that can be
caused by malicious or flawed programs. They should also be useful for
enabling a single system to be used by users with differing security
authorizations to access multiple kinds of information with differing
security requirements without compromising those security requirements.

-- 
Stephen Smalley
National Security Agency


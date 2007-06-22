Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbXFVLiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbXFVLiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXFVLiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:38:11 -0400
Received: from gate.in-addr.de ([212.8.193.158]:52364 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752367AbXFVLiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:38:09 -0400
Date: Fri, 22 Jun 2007 13:37:27 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070622113727.GJ20105@marowsky-bree.de>
References: <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070621211743.GN20105@marowsky-bree.de> <1182511179.24664.1.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1182511179.24664.1.camel@moss-spartans.epoch.ncsc.mil>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-22T07:19:39, Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > > Or can access the data under a different path to which their profile
> > > does give them access, whether in its final destination or in some
> > > temporary file processed along the way.
> > Well, yes. That is intentional.
> > 
> > Your point is?
> 
> It may very well be unintentional access, especially when taking into
> account wildcards in profiles and user-writable directories.

Again, you're saying that AA is not confining unconfined processes.
That's a given. If unconfined processes assist confined processes in
breeching their confinement, yes, that is not mediated.

You're basically saying that anything but system-wide mandatory access
control is pointless.

If you want to go down that route, what is your reply to me saying that
SELinux cannot mediate NFS mounts - if the server is not confined using
SELinux as well? The argument is really, really moot and pointless. Yes,
unconfined actions can affect confined processes. 

That's generally true for _any_ security system.

> > That is an interesting argument, but not what we're discussing here.
> > We're arguing filesystem access mediation.
> IOW, anything that AA cannot protect against is "out of scope".  An easy
> escape from any criticism.

I'm quite sure that this reply is not AA specific as you try to make it
appear.

> > Yes. Your use case is different than mine.
> My use case is being able to protect data reliably.  Yours?

I want to restrict certain possibly untrusted applications and
network-facing services from accessing certain file patterns, because as
a user and admin, that's the mindset I'm used to. I might be interested
in mediating other channels too, but the files are what I really care
about. I'm inclined to trust the other processes.

Your use case mandates complete system-wide mediation, because you want
full data flow analysis. Mine doesn't.



Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde


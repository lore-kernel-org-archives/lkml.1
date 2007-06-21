Return-Path: <linux-kernel-owner+w=401wt.eu-S1759824AbXFUTzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824AbXFUTzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759444AbXFUTyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:54:44 -0400
Received: from gate.in-addr.de ([212.8.193.158]:48212 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759573AbXFUTyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:54:41 -0400
Date: Thu, 21 Jun 2007 21:54:00 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: James Morris <jmorris@namei.org>
Cc: Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070621195400.GK20105@marowsky-bree.de>
References: <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-21T15:42:28, James Morris <jmorris@namei.org> wrote:

> > A veto is not a technical argument. All technical arguments (except for
> > "path name is ugly, yuk yuk!") have been addressed, have they not?
> AppArmor doesn't actually provide confinement, because it only operates on 
> filesystem objects.
> 
> What you define in AppArmor policy does _not_ reflect the actual 
> confinement properties of the policy.  Applications can simply use other 
> mechanisms to access objects, and the policy is effectively meaningless.

Only if they have access to another process which provides them with
that data.

And now, yes, I know AA doesn't mediate IPC or networking (yet), but
that's a missing feature, not broken by design.

> You might define this as a non-technical issue, but the fact that AppArmor 
> simply does not and can not work is a fairly significant consideration, I 
> would imagine.

If I restrict my Mozilla to not access my on-disk mail folder, it can't
get there. (Barring bugs in programs which Mozilla is allowed to run
unconfined, sure.)

If the argument is that AA provides somewhat different semantics - and
for some use cases "weaker" ones - than SE Linux, that is undoubtly
true. However, it appears to be the case that those are the differences
which make AA's model different from SELinux as well, so it appears a
trade-off best left to the admin / user to choose what fits their needs
best.


Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde


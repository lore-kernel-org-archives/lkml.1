Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbXFVKu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbXFVKu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 06:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXFVKuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 06:50:12 -0400
Received: from gate.in-addr.de ([212.8.193.158]:52044 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752160AbXFVKuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 06:50:10 -0400
Date: Fri, 22 Jun 2007 12:49:31 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Joshua Brindle <method@manicmethod.com>, david@lang.hm
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070622104931.GG20105@marowsky-bree.de>
References: <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070621211743.GN20105@marowsky-bree.de> <467B14D9.8050000@manicmethod.com> <Pine.LNX.4.64.0706211722440.31603@asgard.lang.hm> <467B45E0.3040207@manicmethod.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <467B45E0.3040207@manicmethod.com>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-21T23:45:36, Joshua Brindle <method@manicmethod.com> wrote:

> >remember, the policies define a white-list
> 
> Except for unconfined processes.

The argument that AA doesn't mediate what it is not configured to
mediate is correct, yes, but I don't think that's a valid _design_ issue
with AA.

> Or through IPC or the network, that is the point, filesystem only 
> coverage doesn't cut it; there is no way to say the browser can't access 
> the users mail in AA, and there never will be.

We have a variety of filtering mechanisms which are specific to a
domain. iptables filters networking only; file permissions filter file
access only. This argument is not really strong.

<tangent>
If you're now arguing the "spirit of Unix", I can turn your argument
around too: the Unix spirit is to have smallish dedicated tools. If AA
is dedicated to mediating file access, isn't that nice!

AA _could_ be extended to mediate network access and IPC (and this is
WIP). If we had tcpfs and ipcfs - you know, everything is a filesystem,
the Linux spirit! ;-) - AA could mediate them as well.
</tangent>

However, we're discussing the way it mediates file accesses here,
for which it appears useful and capable of functionality which SELinux's
approach cannot provide.


Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbXFVMmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbXFVMmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXFVMmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:42:45 -0400
Received: from gate.in-addr.de ([212.8.193.158]:52789 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752941AbXFVMmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:42:43 -0400
Date: Fri, 22 Jun 2007 14:42:04 +0200
From: Lars Marowsky-Bree <lmb@suse.de>
To: Stephen Smalley <sds@tycho.nsa.gov>, John Johansen <jjohansen@suse.de>
Cc: James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070622124204.GR20105@marowsky-bree.de>
References: <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622080640.GB14593@suse.de> <1182513228.24664.24.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1182513228.24664.24.camel@moss-spartans.epoch.ncsc.mil>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-22T07:53:47, Stephen Smalley <sds@tycho.nsa.gov> wrote:

> > No the "incomplete" mediation does not flow from the design.  We have
> > deliberately focused on doing the necessary modifications for pathname
> > based mediation.  The IPC and network mediation are a wip.
> The fact that you have to go back to the drawing board for them is that
> you didn't get the abstraction right in the first place.

That's an interesting claim, however I don't think it holds. AA was
designed to mediate file access in a form which is intuitive to admins.

It's to be expected that it doesn't directly apply to mediating other
forms of access.

> I think we must have different understandings of the words "generalize"
> and "analyzable".  Look, if I want to be able to state properties about
> data flow in the system for confidentiality or integrity goals (my
> secret data can never leak to unauthorized entities, my critical data
> can never be corrupted/tainted by unauthorized entities - directly or
> indirectly),

I seem to think that this is not what AA is trying to do, so evaluating
it in that context doesn't seem useful. It's like saying a screw driver
isn't a hammer, so it is useless because you have a nail.


Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde


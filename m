Return-Path: <linux-kernel-owner+w=401wt.eu-S1761983AbYHFFum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983AbYHFFum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYHFFue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:50:34 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:23798 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752492AbYHFFud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:50:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ksGUm1q940bBiQt2LGCWNyH9NDR4i0XMFQA/j55/4mjEJ1a477hs7M5UoqDz9dIusaJFkE4YvabLHfQnusS8Lc57eCpsXms2LdENntYQlvV5FqIU7OvmUIxiOxbQU3nD2ySS7zfXXaBQ9XJ08jURQmurvRy0vTrcRs/fHkDMK+w=  ;
X-YMail-OSG: 8FZQtD0VM1nnhR00fQuh9AsXmCD4pUw6brKn6Q9CS5AfxKFbdxT4LL.5scPftOfQd173ukszI7VhaJbu2h9hfmXQbOdypYO8oOZ1r2q8Hsh38Mi6PgTN7SFqrsrV.So.fH9BnBLDSQY3faxKeRM92HLV
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Date: Wed, 6 Aug 2008 15:50:22 +1000
User-Agent: KMail/1.9.5
Cc: jmerkey@wolfmountaingroup.com, "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org>
In-Reply-To: <87r6926dsr.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061550.22996.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 13:08, Andi Kleen wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> > Seriously? Because it doesn't seem to have had enough peer review,
> > it hasn't had widespread testing in somewhere like linux-next or
> > -mm, and we already have kgdb so you have to also explain why you
> > can't improve kgdb in the areas it trails mdb.
> >
> > But the ideal outcome would be if you could contribute patches to
> > kgdb to the point where it is as good as mdb. It is already in the
>
> I don't think kgdb and a simple assembler debugger
> are directly comparable. kgdb always requires a remote machine,
> which has many advantages, but is also often very inconvenient
> or impossible to arrange. An low overhead assembler debugger
> can be always compiled in just in case.
>
> Also at least for the x86 port the debugger interfaces should
> be general enough now (see die hooks as a "debug vfs") that it would
> be quite possible to have a multitude of debuggers just using
> them. In fact that's already the cases, kprobes and kgdb and
> kdump are all kinds of debuggers using such hooks.
>
> As long as it doesn't impact the core code and the mdb
> code itself is considered merge worthy and has clean interfaces
> that would seem fine to me.It essentially would just live somewhere in
> its own directory using the existing interfaces. My standard
> test for seeing if a debugger has clean interfaces is to see
> if it can be loaded as a module.
>
> There are enough different debugging styles around that offering
> developers different tools of which they can pick whatever suits
> them is not a bad idea. Also as everyone knows debugging
> is often a major time eater and if more tools are available that
> can only help the kernel.
>
> That said I haven't read the mdb code, not judging on its general
> merge-worthiness or am really completely sure what are all the details
> of a "netware style debugger", just a general high level comment on
> debuggers. At least judging based on the patch sizes it at least
> doesn't seem particularly bloated.  But of course it would need full
> proper review first.

OK thanks for the info. I don't actually know debugger code as I
said, so I wasn't against merging mdb if it offers things that
kgdb fundamentally cannot.

If so, then ensuring clean interfaces indeed would seem like a
good first step to getting it merged.

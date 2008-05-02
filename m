Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbYEBKho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbYEBKho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759926AbYEBKhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:37:36 -0400
Received: from pascoe.ucs.ed.ac.uk ([129.215.128.240]:40227 "EHLO
	pascoe.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053AbYEBKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:37:35 -0400
X-Greylist: delayed 2483 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 06:37:35 EDT
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Chris Knadle <Chris.Knadle@coredump.us>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Date: Fri, 2 May 2008 10:55:09 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       venkatesh.pallipadi@intel.com, davem@davemloft.net,
       trini@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080501235558.GA20637@orac.ofobscurity.com>
In-Reply-To: <20080501235558.GA20637@orac.ofobscurity.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021055.10602.alistair@devzero.co.uk>
X-Edinburgh-Scanned: at pascoe.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus, Clam AntiVirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

(I fixed the corrupted CC and Reply-to: address from your email.)

On Friday 02 May 2008 00:55:58 Chris Knadle wrote:
> On Thu, 1 May 2008, Linus Torvalds wrote:
> > On Thu, 1 May 2008, Andrew Morton wrote:
> > > > I see only the following choices:
> > > > - remove __weak and replace all current usages
> > > > - move all __weak functions into own files, and ensure that also
> > > > happens for future usages
> > > > - #error for gcc 4.1.{0,1}
> > >
> > > Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?
> >
> > It's __GNUC_PATCHLEVEL__, I believe.
> >
> > So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1}
> > (bad, and rather uncommon).
> > And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare
> > to begin with, I think it's better to just not support it.
> >
> >			Linus
>
>    Unfortunately Debian Stable (i.e. Etch), which is relatively popular for
> server use, is still using 4.1.1  :-(  (The current gcc package is
> gcc-4.1.1-21)
>
>    I have not looked to see if Debian Stable's gcc-4.1.1-21 has been
> patched for the currently discussed __weak bug.

I checked and it has been patched in 4.1.1-21. This would make checking for 
4.1.1 via __GNUC_PATCHLEVEL__ potentially invalid, as patched distro 
compilers may (and in this case do) have this fixed.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

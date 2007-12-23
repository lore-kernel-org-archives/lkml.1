Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbXLWWZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbXLWWZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 17:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXLWWZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 17:25:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56743 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbXLWWZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 17:25:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.24-rc6-mm1
Date: Sun, 23 Dec 2007 23:44:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20071222233056.d652743e.akpm@linux-foundation.org> <200712231453.35497.rjw@sisk.pl> <20071223200946.GA21826@uranus.ravnborg.org>
In-Reply-To: <20071223200946.GA21826@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712232344.39302.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of December 2007, Sam Ravnborg wrote:
> On Sun, Dec 23, 2007 at 02:53:34PM +0100, Rafael J. Wysocki wrote:
> > On Sunday, 23 of December 2007, Rafael J. Wysocki wrote:
> > > On Sunday, 23 of December 2007, Ingo Molnar wrote:
> > > > 
> > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > 
> > > > > Well it doesn't build on x86-64 for me:
> > > > > 
> > > > >   CHK     include/linux/compile.h
> > > > >   CC      arch/x86/ia32/../../../fs/compat_binfmt_elf.o
> > > > > Assembler messages:
> > > > > Fatal error: can't create arch/x86/ia32/../../../fs/.tmp_compat_binfmt_elf.o: No such file or directory
> > > > > make[2]: *** [arch/x86/ia32/../../../fs/compat_binfmt_elf.o] Error 2
> > > > > 
> > > > > I will post the .config if anyone is interested.
> > > > 
> > > > yes, please send the .config.
> > > 
> > > Attached.
> > > 
> > > It also may be relevant that I compile the kernel with "make O=../build".
> > 
> > I ran the compilation once again and it worked.  Strange.
> Try to delete your fs/ directory in your output dir.
> Then I expect the same bug to surface again.

It does surface indeed.

> I guess it is because arch/x86/ia32/ is built before fs/ and
> gcc cannot create directories for the output files and
> it is the dependency files that triggers the error as this
> is the first file to be generated.

I think you are right.

Greetings,
Rafael

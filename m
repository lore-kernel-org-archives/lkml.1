Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZITOkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZITOkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 10:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZITOkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 10:40:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZITOku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 10:40:50 -0400
Subject: Re: Feedback on "kbuild: generate modules.builtin"
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: akpm@linux-foundation.org, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org, JBeulich@novell.com,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090920132856.GA26845@merkur.ravnborg.org>
References: <200909181949.n8IJnT4R019097@imap1.linux-foundation.org>
	 <20090920132856.GA26845@merkur.ravnborg.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sun, 20 Sep 2009 10:40:52 -0400
Message-Id: <1253457652.20020.630.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-20 at 15:28 +0200, Sam Ravnborg wrote:
> On Fri, Sep 18, 2009 at 12:49:29PM -0700, akpm@linux-foundation.org wrote:
> > From: Michal Marek <mmarek@suse.cz>
> > 
> > To make it easier for tools like mkinitrd to detect whether a needed
> > module is missing or whether it is compiled into the kernel, install a
> > modules.builtin file listing all modules built into the kernel.  This is
> > done by generating an alternate config file with all tristate =y options
> > set to =Y and reading the makefiles with this config included.  The built
> > in modules then appear in obj-Y.
> 
> Hi Michael.
> 
> [Added Steven on cc: as he had done some kconfig
>  hacking lately].

Thanks!

> 
> Got some time (finally) to look at this.

Unfortunately, I'm about to leave for two weeks. I got LinuxCon and
LinuxPlumbers to present at in Portland, then I fly off to Dresden
Germany to present at OSADL conference there. So I wont have anytime to
look at this until I'm done with these.

But please, keep me posted on any changes like this.

Thanks,

-- Steve


> I understand the functionality and I have myself had the need
> to see builtin modules.
> 
> As for the implmentation I have a few comments.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYJaOWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYJaOWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYJaOWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:22:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:53058 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYJaOWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:22:11 -0400
Message-ID: <f73f7ab80810310722ja2cde63va46bacf59ca1698f@mail.gmail.com>
Date: Fri, 31 Oct 2008 10:22:09 -0400
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "J.R. Mauro" <jrm8005@gmail.com>
Subject: Re: merging other repos into linux-2.6
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <3aaafc130810310557p1c9c67c0t4407209955668839@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081030054944.GA19035@kroah.com>
	 <3aaafc130810301834w554fbd33p6f423ffef77e92aa@mail.gmail.com>
	 <alpine.LFD.2.00.0810301843220.21084@nehalem.linux-foundation.org>
	 <3aaafc130810301938k4ee654d6sf7de1fff5d9c9fc3@mail.gmail.com>
	 <f73f7ab80810302108n37f72994qfc5d7d83b64e290@mail.gmail.com>
	 <3aaafc130810310557p1c9c67c0t4407209955668839@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 8:57 AM, J.R. Mauro <jrm8005@gmail.com> wrote:
> On Fri, Oct 31, 2008 at 12:08 AM, Kyle Moffett <kyle@moffetthome.net> wrote:
>> Now the history of $KIDBRANCH will appear to be a series of commits
>> which add files in $SUBDIR of the parent project, without any changes
>> at all to the parent project's tree.  You can then do a merge of what
>> appears to be a normal development branch into the main repository.
>>
>> Since none of the files are even remotely referenced, there can be no
>> possible build failures (hence bisection is not broken).  You may then
>> add commits which add Kconfig options and Makefile references and
>> happily develop away.
>
> So this would keep their history but make it look like their first
> commit (years ago) happened today? Or do I misunderstand you?

Not really, since GIT will preserve the original commit date
information when doing the filtering.  Essentially it's equivalent to
taking some ancient long git branch of a project and doing a "git
rebase" onto a recent kernel.  The difference is that there is no
common ancestor and the entire contents of one are mapped onto a
subdirectory of the other.  I'm trying to figure out if this would be
a useful addition to the "git rebase" functionality (since that's
essentially what it is).

> But then if Greg thinks the history is rubbish, I doubt it will get
> imported, although I think these methods are worth experimenting with
> for the future.

Oh, I very much agree that importing a bunch of dodgy changelogs is
hardly worth it.  The biggest difference between the Linux kernel and
most other software projects is the Linux kernel has some of the best
changelogs and one of the most bisectable histories.

Greg did say he had another project he wanted to import, though, so I
figured I'd post another suggestion about how to merge the projects
histories together.

Cheers,
Kyle Moffett

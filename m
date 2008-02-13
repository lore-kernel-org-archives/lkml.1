Return-Path: <linux-kernel-owner+w=401wt.eu-S1762697AbYBMHkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762697AbYBMHkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbYBMHkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:40:35 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:63628 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbYBMHke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CODun3sASnSlQFdYhi7j3glwAmVauZPKFH9/aq/H9OcIltW0Sa55/QFyN20feyHA4W/LuhEmG29I9awowfAD39qwe0dPy5VwarG94yFQoMbXK+0LL4kqEsQ6qS1levoT6HZ/NW1N1rL8qnW/h/tShgIT4IXYsnPwng/+54lfZ2Q=
Message-ID: <804dabb00802122340t555e3c26ma903ef97991dd13@mail.gmail.com>
Date: Wed, 13 Feb 2008 15:40:32 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Documentation about sysfs/procfs entries
Cc: "Scott Lovenberg" <scott.lovenberg@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Mulyadi Santosa" <mulyadi.santosa@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <20080213073159.GA13414@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00802112123t774623b2n3e1e0a4addde1512@mail.gmail.com>
	 <b1fc6a560802112217j57ab3fa1h611864a6a2423943@mail.gmail.com>
	 <804dabb00802112346q240745abm93b6257f2cd64e60@mail.gmail.com>
	 <47B15DD2.3090706@gmail.com>
	 <f284c33d0802121808v2e41b648u83070ac1f6f1bb2a@mail.gmail.com>
	 <20080212204348.4a858650.randy.dunlap@oracle.com>
	 <47B2874F.5000805@gmail.com> <20080213073159.GA13414@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/08, Greg KH <greg@kroah.com> wrote:
> On Wed, Feb 13, 2008 at 12:59:43AM -0500, Scott Lovenberg wrote:
> > Randy Dunlap wrote:
> >> On Wed, 13 Feb 2008 09:08:12 +0700 Mulyadi Santosa wrote:
> >>
> >>
> >>> Hi all...
> >>>
> >>> Here's my idea: what if we collaborate to extend and make the kernel
> >>> documentation better? I have done (slow) start by editing profile=
> >>> kernel param. It's not accepted by Adrian Bunk, but at least I did it.
> >>> Feedback?
> >>>
> >>
> >> Adrian is no longer the trivial patch maintainer.
> >> Did you send the patch to trivial@kernel.org ?
> >>
> >> Any doc additions or improvements would be appreciated.
> >> I'll be glad to help get them merged...
> >>
> >> ---
> >> ~Randy
> >>
> >>
> > I'd love to help, but I'm a bit of a newbie; what's protocol for
> > documentation updates, standard diffs?
>
> Yes.
>
> > How are we going to attack this thing, cleaning up and updating existing
> > documentation first and then adding undocumented items, or file by file
> > updating and adding in one fell swoop?
>
> File by file.
>
> And please place the new documentation of sysfs and procfs entries into
> the framework in the Documentation/ABI/ directory tree, which is where
> it belongs.
>
> thanks,
>
> greg k-h
>

some questions:

a.   the list of parameters can presumably be extracted from existing
file via "procname" search.....not sure if it is correct (as per
attached, complete?)

b.   what is the diff between /proc and /sys?   in
Documentation/filesystems/proc.txt....it is mentioned that /proc
information will be published into a book...where is it?   I can never
understand this.

c.   in Doc/sysctl are all the explanation for /proc/sys/* .... as a
start i think we shall contribute fixing here....but according to your
email, we should fix Doc/ABI...so I supposed some migration is needed?

d.   In networking/ip-sysctl.txt a lot of the explanation for the
attached procname's parameters are explained, may be we can relocate
it to ABI?

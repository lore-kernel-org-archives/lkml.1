Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbXLAVFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbXLAVFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 16:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXLAVFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 16:05:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:41189 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbXLAVFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 16:05:37 -0500
Message-ID: <cccedfc60712011305u27b8d6fbuc6c7c7bf4ac53268@mail.gmail.com>
Date: Sat, 1 Dec 2007 15:05:34 -0600
From: "Jon Nelson" <jnelson@jamponi.net>
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Cc: jnelson-kernel-bugzilla@jamponi.net, bugme-daemon@bugzilla.kernel.org,
       "Ed L. Cashin" <ecashin@coraid.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20071201122302.10dd9c44.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-9482-10286@http.bugzilla.kernel.org/>
	 <20071201122302.10dd9c44.akpm@linux-foundation.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> (switched to email - please respond via emailed reply-to-all, not via the
> bugzilla web interface)
>
> On Sat,  1 Dec 2007 11:54:11 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
>
> > http://bugzilla.kernel.org/show_bug.cgi?id=9482
> >
> >            Summary: kernel GPF in 2.6.24 (g09f345da)
> >            Product: Other
> >            Version: 2.5
> >      KernelVersion: 2.6.24rc3 g09f345da
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Other
> >         AssignedTo: other_other@kernel-bugs.osdl.org
> >         ReportedBy: jnelson-kernel-bugzilla@jamponi.net
> >
> >
> > Most recent kernel where this bug did not occur: 2.6.22.12
> > Distribution: openSUSE 10.3
> > Hardware Environment: Athlon XP 2200+
> > Software Environment: openSUSE 10.3
> > Problem Description: instant kernel GPF.
> >
> > Steps to reproduce:load module aoe (vanilla), type 'mkfs.ext3
> > /dev/etherd/e0.0', and the kernel GPFs.
> >
> > Will be attaching jpg of screen - sorry, no other way to capture GPF for me.
> >
>
> http://bugzilla.kernel.org/attachment.cgi?id=13812&action=view
>
> Damn that's odd.  General Protection Fault in
> __set_page_dirty->__percpu_counter_add().  No sign of AOE in the trace.
>
> I assume that it is repeatable and that it doesn't occur with mkfs on
> regular local disk drives?


This works fine:

mkfs.ext3 /dev/system/test #### a local LVM2-based logical volume

mkfs.ext3 /dev/etherd/e0.0 ## Boom.




-- 
Jon

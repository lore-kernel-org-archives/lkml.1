Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZBCT3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZBCT3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbZBCT3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:29:00 -0500
Received: from vuizook.err.no ([85.19.221.46]:50325 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbZBCT24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:28:56 -0500
X-Greylist: delayed 2355 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 14:28:56 EST
Date: Tue, 3 Feb 2009 19:49:15 +0100
From: Mike Hommey <mh@glandium.org>
To: Paul Menage <menage@google.com>
Cc: Gustavo Noronha <kov@debian.org>, debian-devel@lists.debian.org,
       linux-kernel@vger.kernel.org
Subject: Re: cgroup mount point
Message-ID: <20090203184915.GA10004@glandium.org>
Mail-Followup-To: Paul Menage <menage@google.com>,
	Gustavo Noronha <kov@debian.org>, debian-devel@lists.debian.org,
	linux-kernel@vger.kernel.org
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com> <20090203102416.GA8886@redhat.com> <87ljsnzo4v.fsf@benfinney.id.au> <1233671913.8902.53.camel@abacate.horta> <6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com>
X-GPG-Fingerprint: A479 A824 265C B2A5 FC54  8D1E DE4B DA2C 54FD 2A58
Organization: glandium.org
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 08:55:34AM -0800, Paul Menage wrote:
> On Tue, Feb 3, 2009 at 6:38 AM, Gustavo Noronha <kov@debian.org> wrote:
> > On Tue, 2009-02-03 at 23:44 +1100, Ben Finney wrote:
> >> I agree with all that Thadeu Lima says here. I would add that cgroups
> >> are nothing to do with device nodes, so definitely don't belong in
> >> '/dev/' either.
> >>
> >> Since they're a filesystem mapping "for browsing and manipulation
> >> from user space" of a kernel facility, I think '/sys/cgroups/' is
> >> appropriate.
> >
> > I agree with this point of view. I believe /sys/cgroups is the way to
> > go. Now, of course this has the drawback of shadowing something future
> > versions of Linux would make available at that same path, but I am
> > pretty sure they would be careful not to do that after distributions
> > have settled on a standard path.
> 
> Having one virtual filesystem mounted on top of another virtual
> filesystem seems like a recipe for problems.

Like with /sys/fs/fuse/connections ? Come on, there is no problem with a
virtual filesystem mounted on top of another.

Mike

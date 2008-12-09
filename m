Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYLIUva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYLIUva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYLIUvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:51:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45565 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbYLIUvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:51:17 -0500
Date: Tue, 9 Dec 2008 15:49:32 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Dennis Hardy" <dhardy@sogetthis.com>, linux-kernel@vger.kernel.org,
       layton@redhat.com, "Steven French" <sfrench@us.ibm.com>,
       "Greg KH" <gregkh@suse.de>, netdev@vger.kernel.org,
       Holger Hoffstaette <holger@wizards.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: CIFS regression in 2.6.27.8
Message-ID: <20081209154932.0952fbf3@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <200812082112.49468.rjw@sisk.pl>
References: <20900699.post@talk.nabble.com>
	<84144f020812081128p6d1e2a55v69996a360e7f0e8f@mail.gmail.com>
	<200812082112.49468.rjw@sisk.pl>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008 21:12:48 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, 8 of December 2008, Pekka Enberg wrote:
> > Hi Dennis,
> > 
> > On Mon, Dec 8, 2008 at 8:18 PM, Dennis Hardy <dhardy@sogetthis.com> wrote:
> > > I just mounted a network drive (Windows Server) via CIFS under 2.6.27.8, and
> > > the sizes reported by "df" are completely incorrect:
> > >
> > >  root@exodus:~# df -h /mnt/fsv1
> > >  Filesystem            Size  Used Avail Use% Mounted on
> > >  //fsv1/Users          446G -222G  667G   -  /mnt/fsv1
> > >  root@exodus:~# df /mnt/fsv1
> > >  Filesystem           1K-blocks      Used Available Use% Mounted on
> > >  //fsv1/Users         467403140 -231816588 699219728   -  /mnt/fsv1
> > >  root@exodus:~# mount | grep fsv1
> > >  //fsv1/Users on /mnt/fsv1 type cifs (rw,mand)
> > >  root@exodus:~#
> > >
> > > Does anyone else see this sort of behavior with 2.6.27.8?  This worked fine
> > > in 2.6.27.6 (we skipped 2.6.27.7)...
> > >

I tried it on both i386 and x86_64 and had no problems. Is this client
non-x86 by any chance?

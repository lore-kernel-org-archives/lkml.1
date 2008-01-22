Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761AbYAVO6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbYAVO6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYAVO6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:58:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYAVO6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:58:22 -0500
Date: Tue, 22 Jan 2008 12:57:53 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Theodore Tso <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
       David Chinner <dgc@sgi.com>, Valerie Henson <val@vahconsulting.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>,
       Ric Wheeler <ric@emc.com>, marcelo@kvack.org
Subject: Re: [RFC] Parallelize IO for e2fsck
Message-ID: <20080122145753.GC32529@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
	David Chinner <dgc@sgi.com>, Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>, Ric Wheeler <ric@emc.com>,
	marcelo@kvack.org
References: <70b6f0bf0801161322k2740a8dch6a0d6e6e112cd2d0@mail.gmail.com> <70b6f0bf0801161330y46ec555m5d4994a1eea7d045@mail.gmail.com> <20080121230041.GL3180@webber.adilger.int> <20080122033830.GR155259@sgi.com> <3673.1200975438@turing-police.cc.vt.edu> <20080122070050.GM3180@webber.adilger.int> <20080122144052.GC17804@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122144052.GC17804@mit.edu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 22, 2008 at 09:40:52AM -0500, Theodore Tso escreveu:
> On Tue, Jan 22, 2008 at 12:00:50AM -0700, Andreas Dilger wrote:
> > > AIX had SIGDANGER some 15 years ago.  Admittedly, that was sent when
> > > the system was about to hit OOM, not when it was about to start swapping.
> > 
> > I'd tried to advocate SIGDANGER some years ago as well, but none of
> > the kernel maintainers were interested.  It definitely makes sense
> > to have some sort of mechanism like this.  At the time I first brought
> > it up it was in conjunction with Netscape using too much cache on some
> > system, but it would be just as useful for all kinds of other memory-
> > hungry applications.
> 
> It's been discussed before, but I suspect the main reason why it was
> never done is no one submitted a patch.  Also, the problem is actually
> a pretty complex one.  There are a couple of different stages where
> you might want to send an alert to processes:

Isn't Marcelo, Riel and some other people working on memory
notifications?

- Arnaldo

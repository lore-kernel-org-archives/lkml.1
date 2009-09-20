Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbZITWEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbZITWEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 18:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZITWED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 18:04:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZITWED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 18:04:03 -0400
Date: Mon, 21 Sep 2009 00:04:05 +0200
From: Jan Kara <jack@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: Poor desktop responsiveness with background I/O-operations
Message-ID: <20090920220405.GA395@duck.suse.cz>
References: <4AB59CBB.8090907@datenparkplatz.de> <alpine.LRH.2.00.0909202221010.25928@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0909202221010.25928@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 20-09-09 22:22:20, Jiri Kosina wrote:
> On Sun, 20 Sep 2009, Ulrich Lukas wrote:
> 
> > Test case:
> > - 64-bit dual-core PC, SATA harddrive, plenty of free RAM
> > - vanilla Linux 2.6.31, Kubuntu 9.10 packages, all software 64-bit
> > 
> > 
> > How to reproduce:
> > - start KDE/GNOME-session
> > - open a terminal window and do as a non-root user:
> >   dd if=/dev/zero of=/home/john-doe/testfile
> >   (or dd if=/home/john-doe/big-testfile of=/dev/null)
> > 
> > - a real use scenario would be a daily disk-backup or the
> >   simple extraction of a tarball containing slightly bigger files
> > 
> > 
> > Observation:
> > - The system becomes _really_ slow as described above; unusable for
> >   any multimedia tasks.
> 
> I guess that switching from CFQ to deadline I/O scheduler improves the 
> situation, right?
  For example on my desktop, switching to deadline slightly improves the
situation but the machine is still mostly unusable while dd is running...
I'll try to debug it some more to see whether it can be somehow helped.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

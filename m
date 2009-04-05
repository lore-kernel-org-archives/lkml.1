Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbZDEG0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbZDEG0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 02:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZDEG0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 02:26:34 -0400
Received: from thunk.org ([69.25.196.29]:58284 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbZDEG0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 02:26:33 -0400
Date: Sun, 5 Apr 2009 02:26:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: IO latency - a special case
Message-ID: <20090405062626.GA7760@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Trenton D. Adams" <trenton.d.adams@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com> <9b1675090904041131u28635d8dnc3d13e88000394b4@mail.gmail.com> <20090405011355.GE7553@mit.edu> <9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com> <9b1675090904042125g708076e6v665f5ecc7fa020a4@mail.gmail.com> <9b1675090904042313rb8178b6v1da3aeddfa57a869@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b1675090904042313rb8178b6v1da3aeddfa57a869@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 12:13:44AM -0600, Trenton D. Adams wrote:
> Hi Ted,
> 
> I have no idea what "sar" is, and a google search doesn't appear to
> reveal anything useful.  Where can I get this "sar" tool?
> 
> I also do not have "iostat" on my system, and again, google does not
> appear to reveal an official page for that, and gentoo doesn't appear
> to have a package for it.

Both "sar" and "iostat" are part of the sysstat package.

Package: sysstat
Priority: optional
Section: admin
Installed-Size: 808
Maintainer: Ubuntu MOTU Developers <ubuntu-motu@lists.ubuntu.com>
Original-Maintainer: Robert Luberda <robert@debian.org>
Architecture: i386
Version: 8.1.2-2ubuntu1
Depends: libc6 (>= 2.4), debconf (>= 0.5) | debconf-2.0, ucf (>= 2.003), lsb-base (>= 3.0-6), bzip2
Recommends: cron
Suggests: isag
Conflicts: atsar (<< 1.5-3)
Filename: pool/main/s/sysstat/sysstat_8.1.2-2ubuntu1_i386.deb
Size: 182222
MD5sum: e59153e0121ce437082ab7e03fe647e0
SHA1: 65383dec2ca6ea4fa5fed41afdde46639d2d5e98
SHA256: eb5530307e52ef69b9d1d3c0e43e7a02e805888e183adcbef272bf9283829851
Description: sar, iostat and mpstat - system performance tools for Linux
 The sysstat package contains the following system performance tools:
  * sar - collects and reports system activity information;
  * iostat - reports CPU utilization and I/O statistics for disks;
  * mpstat - reports global and per-processor statistics;
  * pidstat - reports statistics for Linux tasks (processes);
  * sadf - displays data collected by sar in various formats.
 .
 The statistics reported by sar concern I/O transfer rates,
 paging activity, process-related activities, interrupts,
 network activity, memory and swap space utilization, CPU
 utilization, kernel activities and TTY statistics, among
 others. Both UP and SMP machines are fully supported.
Homepage: http://pagesperso-orange.fr/sebastien.godard/
Bugs: mailto:ubuntu-users@lists.ubuntu.com
Origin: Ubuntu

						- Ted

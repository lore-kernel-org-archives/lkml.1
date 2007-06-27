Return-Path: <linux-kernel-owner+w=401wt.eu-S1763061AbXF0Tcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763061AbXF0Tcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbXF0TcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:32:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761242AbXF0TcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:32:11 -0400
Date: Wed, 27 Jun 2007 12:31:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, josh@kernel.org
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
Message-Id: <20070627123122.257661e3.akpm@linux-foundation.org>
In-Reply-To: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 10:59:20 -0700
Josh Triplett <josht@linux.vnet.ibm.com> wrote:

> +Do not leave trailing whitespace at the ends of lines.  Some editors with
> +"smart" indentation will insert whitespace at the beginning of new lines as
> +appropriate, so you can start typing the next line of code right away.
> +However, some such editors do not remove the whitespace if you end up not
> +putting a line of code there, such as if you leave a blank line.  As a result,
> +you end up with lines containing trailing whitespace.
> +
> +Git will warn you about patches that introduce trailing whitespace, and can
> +optionally strip the trailing whitespace for you; however, if applying a series
> +of patches, this may make later patches in the series fail by changing their
> +context lines.

quilt has ways of detecting and/or correcting newly-added trailing
whitespace, but I don't know the details.

One could share the various scriptlets which detect and fix trailing
whitespace but I think this issue is getting less and less important
now, because most maintainers will zap the new whitespace prior to
merging.

<checks>

akpm:/usr/src/25> grep -l "^+.*[        ]$" patches/git-*.patch
patches/git-acpi.patch
patches/git-alsa.patch
patches/git-battery.patch
patches/git-cifs.patch
patches/git-drm.patch
patches/git-gfs2-nmw.patch
patches/git-hid.patch
patches/git-ipwireless_cs.patch
patches/git-ixgbe.patch
patches/git-kgdb.patch
patches/git-leds.patch
patches/git-libata-all.patch
patches/git-md-accel.patch
patches/git-netdev-all.patch
patches/git-newsetup.patch
patches/git-nfs.patch
patches/git-ocfs2.patch
patches/git-pciseg.patch
patches/git-qla3xxx.patch
patches/git-selinux.patch
patches/git-sym2.patch
patches/git-unionfs.patch
patches/git-watchdog.patch
patches/git-wireless.patch

damn.  Bunch of lamers.

But there's less than there used to be.

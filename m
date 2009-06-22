Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbZFVPH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbZFVPH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZFVPHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:07:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35261 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZFVPHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:07:16 -0400
Date: Mon, 22 Jun 2009 11:07:14 -0400
From: Dave Jones <davej@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@novell.com>
Subject: Re: backtraces when mounting ext2 with sync option.
Message-ID: <20090622150714.GC6963@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Nick Piggin <npiggin@novell.com>
References: <20090621173448.GB26093@redhat.com> <x49k534l48l.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49k534l48l.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 10:42:18AM -0400, Jeff Moyer wrote:
 > Dave Jones <davej@redhat.com> writes:
 > 
 > > I see this when I mount an ext2 usb stick with the -o sync option.
 > >
 > > 	Dave
 > >
 > > ------------[ cut here ]------------
 > > WARNING: at fs/fs-writeback.c:292 __writeback_single_inode+0x125/0x287()
 > 
 > 292:         WARN_ON(inode->i_state & I_NEW);
 > 
 > > WARNING: at fs/fs-writeback.c:317 __writeback_single_inode+0x1d3/0x287()
 > 
 > 317:         WARN_ON(inode->i_state & I_NEW);
 > 
 > http://marc.info/?l=linux-fsdevel&m=124393728021298&w=2
 > 
 > Nick already sent a patch to fix this.

Ah cool. Looks like one for -stable.

	Dave


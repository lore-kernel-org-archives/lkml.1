Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZFVOmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZFVOmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZFVOmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:42:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60320 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZFVOmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:42:17 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@novell.com>
Subject: Re: backtraces when mounting ext2 with sync option.
References: <20090621173448.GB26093@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 22 Jun 2009 10:42:18 -0400
In-Reply-To: <20090621173448.GB26093@redhat.com> (Dave Jones's message of
	"Sun, 21 Jun 2009 13:34:48 -0400")
Message-ID: <x49k534l48l.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> I see this when I mount an ext2 usb stick with the -o sync option.
>
> 	Dave
>
> ------------[ cut here ]------------
> WARNING: at fs/fs-writeback.c:292 __writeback_single_inode+0x125/0x287()

292:         WARN_ON(inode->i_state & I_NEW);

> WARNING: at fs/fs-writeback.c:317 __writeback_single_inode+0x1d3/0x287()

317:         WARN_ON(inode->i_state & I_NEW);

http://marc.info/?l=linux-fsdevel&m=124393728021298&w=2

Nick already sent a patch to fix this.

Cheers,
Jeff

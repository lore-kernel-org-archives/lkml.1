Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbXLSRoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbXLSRoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbXLSRoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:44:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60420 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbXLSRn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:43:59 -0500
To: Eric Sandeen <sandeen@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Michael Halcrow <mhalcrow@us.ibm.com>,
       mike@halcrow.us
Subject: Re: [PATCH] ecryptfs: redo dget,mntget on dentry_open failure
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <47695621.6040709@redhat.com>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Wed, 19 Dec 2007 12:42:50 -0500
In-Reply-To: <47695621.6040709@redhat.com> (Eric Sandeen's message of "Wed\, 19 Dec 2007 11\:34\:25 -0600")
Message-ID: <x49prx237j9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen <sandeen@redhat.com> writes:

> Thanks to Jeff Moyer for pointing this out.
>
> If the RDWR dentry_open() in ecryptfs_init_persistent_file fails,
> it will do a dput/mntput.  Need to re-take references if we
> retry as RDONLY.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Thanks,

Jeff

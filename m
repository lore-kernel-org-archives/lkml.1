Return-Path: <linux-kernel-owner+w=401wt.eu-S933670AbZJGNQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbZJGNQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933588AbZJGNQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:16:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933457AbZJGNQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:16:22 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Nick Piggin <npiggin@novell.com>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NULL inode->i_mapping in generic_sync_sb_inodes
References: <4ACC9E8A0200008A000439B0@novprvlin0050.provo.novell.com>
	<x49ocoj2yuo.fsf@segfault.boston.devel.redhat.com>
	<20091007124327.GT30316@wotan.suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 07 Oct 2009 09:15:47 -0400
In-Reply-To: <20091007124327.GT30316@wotan.suse.de> (Nick Piggin's message of
	"Wed, 7 Oct 2009 14:43:27 +0200")
Message-ID: <x497hv7tke4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

>> hch mentioned that it would be good to instrument to what file system
>> the inode belonged.  Anything else you'd like to look at?
>
> Not too sure. I guess i_state. Maybe you could take s_umount lock
> and see if it is still mounted?
>
> Actually most useful will be to find all places where i_mapping is
> set to NULL, and record in the inode some callchain for the last
> site which set i_mapping to NULL. Dump this stack when you hit the
> bug.

Well, I can't find a single place where i_mapping is set to NULL.  ;-)
I'll see what I can dig up.

Cheers,
Jeff

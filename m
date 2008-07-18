Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbYGRUKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbYGRUKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYGRUJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:09:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYGRUJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:09:55 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/7] autofs4 - remove unused ioctls
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
	<20080718023751.12802.96268.stgit@raven.themaw.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 18 Jul 2008 16:09:48 -0400
In-Reply-To: <20080718023751.12802.96268.stgit@raven.themaw.net> (Ian Kent's
	message of "Fri, 18 Jul 2008 10:37:52 +0800")
Message-ID: <x497ibjc5tf.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> The ioctls AUTOFS_IOC_TOGGLEREGHOST and AUTOFS_IOC_ASKREGHOST were
> added several years ago but what they were intended for has never
> been implemented (as far as I'm aware noone uses them) so remove them.

Yeah, the only other consumer of the autofs interfaces (that I know) is
autodir, and that doesn't use the reghost ioctls.

> Signed-off-by: Ian Kent <raven@themaw.net>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

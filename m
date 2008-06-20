Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbYFTNDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbYFTNDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYFTNDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:03:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbYFTNDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:03:10 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] autofs4 - add missing kfree
References: <20080620070923.17224.33149.stgit@raven.themaw.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 20 Jun 2008 09:02:32 -0400
In-Reply-To: <20080620070923.17224.33149.stgit@raven.themaw.net> (Ian Kent's
	message of "Fri, 20 Jun 2008 15:09:25 +0800")
Message-ID: <x49ej6stg2f.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> It see that the patch tittled "autofs4 - fix pending mount race" is
> missing a change that I had recently made.
>
> It's missing a kfree for the case mutex_lock_interruptible() fails
> to aquire the wait queue mutex.

Yeah, missed that in the translation to the embedded qstr.

> Ian
>
> Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

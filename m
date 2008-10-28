Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYJ1Oc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYJ1Oc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYJ1OcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:32:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42536 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbYJ1OcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:32:16 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/2] autofs4 - fix string validation check order
References: <20081028053047.29379.19919.stgit@zeus.themaw.net>
	<20081028053053.29379.15598.stgit@zeus.themaw.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 28 Oct 2008 09:25:37 -0400
In-Reply-To: <20081028053053.29379.15598.stgit@zeus.themaw.net> (Ian Kent's
	message of "Tue, 28 Oct 2008 14:30:53 +0900")
Message-ID: <x49prlk6ecu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> In function validate_dev_ioctl() we check that the string we've
> been sent is a valid path. The function that does this check
> assumes the string is NULL terminated but our NULL termination
> check isn't done until after this call. This patch changes the
> order of the check.
>
> Signed-off-by: Ian Kent <raven@themaw.net>
Acked-by: Jeff Moyer <jmoyer@redhat.com>

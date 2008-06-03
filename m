Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbYFCMJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbYFCMJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 08:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYFCMJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 08:09:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52601 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbYFCMJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 08:09:03 -0400
Date: Tue, 3 Jun 2008 13:08:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Miklos Szeredi <miklos@szeredi.hu>, drepper@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Message-ID: <20080603120850.GZ28946@ZenIV.linux.org.uk>
References: <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com> <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com> <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu> <20080603112221.GW28946@ZenIV.linux.org.uk> <cfd18e0f0806030427p22a274dev746e1656662f34f6@mail.gmail.com> <20080603113018.GA27955@shareable.org> <cfd18e0f0806030439n5a11fa4aocd6251ffab66b6dd@mail.gmail.com> <20080603114921.GX28946@ZenIV.linux.org.uk> <20080603120135.GA28905@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603120135.GA28905@shareable.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 01:01:35PM +0100, Jamie Lokier wrote:
> > with a lot of things, starting with "why utimes(2) has weaker requirements
> > with NULL argument", but we are far too late to fix that.
> 
> To be fair, having a writable file descriptor only lets you change the
> mtime to "now", and having a readable file descriptor only lets you
> change the atime to "now".
> 
> Changing the times _in general_ can be seen as over-reaching those
> capabilities and arguably justifies more strict checks.

Which is what all questions about writability apply only to NULL case
anyway...

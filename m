Return-Path: <linux-kernel-owner+w=401wt.eu-S1765722AbXKOSh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765722AbXKOSh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbXKOShW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:37:22 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:14086 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759660AbXKOShV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WkV6w58SJ7jw6D9YAs0Drb8IyWSEuTJ6zMZJSepF9djdgtuU6wOKaZI9vubR65i2MkNxNjp1Fgpz0kbV7tfOglitEZPDKCOPpS+hGxVhKaV3AruRi/A3NtG0/EfoM4yR5JijID0ahOgJxyS+EPcbdffBRQmh35nz7bSTEKTfiOw=
Message-ID: <64bb37e0711151036h2a657a37tf3231ae2e9408d4d@mail.gmail.com>
Date: Thu, 15 Nov 2007 19:36:59 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jan Blunck" <jblunck@suse.de>
Subject: Re: 2.6.24-rc2-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>
In-Reply-To: <20071115173627.GG25521@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com>
	 <20071114122939.7b4ee194.akpm@linux-foundation.org>
	 <64bb37e0711141448h15c667dbn4496870dd64a0457@mail.gmail.com>
	 <20071115173627.GG25521@hasse.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 6:36 PM, Jan Blunck <jblunck@suse.de> wrote:
> On Wed, Nov 14, Torsten Kaiser wrote:
>
> > > > So I can create new directories, but not new files. Reading files works normal.
> > > >>
> > > > The client is 2.6.24-rc2-mm1, the server 2.6.22-gentoo-r9.
> >
> > I added Jan Blunck to the recipents, as he wrote
> > use-struct-path-in-struct-svc_expkey and
> > use-struct-path-in-struct-svc_export
>
> These patches only change the server code. Hard to imagine how this could
> break the client. The other patches are pure cleanups only.

Sorry to have bothered you. But these were the only ones that touched
any nfs code.
But this list was wrong anyway.

I just found out that I botched the bisect, now doing the wrong part again.
(compile error scrolled of the screen and I copied/tested the same kernel again)

Torsten

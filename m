Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZJKVny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZJKVny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 17:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZJKVnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 17:43:53 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33968 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZJKVnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 17:43:52 -0400
Date: Sun, 11 Oct 2009 23:43:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a
	kernel
Message-ID: <20091011214315.GC2768@merkur.ravnborg.org>
References: <20090720100157.GA6467@merkur.ravnborg.org> <1255078929.17055.40.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255078929.17055.40.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 11:02:09AM +0200, Peter Zijlstra wrote:
> On Mon, 2009-07-20 at 12:01 +0200, Sam Ravnborg wrote:
> > This works both for plain builds and for O=...
> > builds.
> > So now you can do:
> > $ mkdir sparc64
> > $ make O=sparc64 ARCH=sparc64 CROSS_COMPILE=sparc64-linux- defconfig
> > $ cd sparc64
> > $ make
> 
> Like anyone who does a lot of cross builds will ever write that by
> hand..

I usually have the first three lines scripted.
And when entering _any_ arch specific directory it
is convinient just to type 'make'.

And yes - I do a lot of cross builds as kbuild by nature
is not tied to a specific architecture.

	Sam

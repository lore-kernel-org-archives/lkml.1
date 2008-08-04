Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbYHDXlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbYHDXlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbYHDXlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:41:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755130AbYHDXlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:41:35 -0400
Date: Mon, 4 Aug 2008 16:41:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Paul Jackson <pj@sgi.com>, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 2/2] cpuset: use seq_cpumask(), seq_nodemask()
Message-Id: <20080804164101.51190a8b.akpm@linux-foundation.org>
In-Reply-To: <20080802142838.GA338@martell.zuzino.mipt.ru>
References: <20080802113131.GB3536@martell.zuzino.mipt.ru>
	<20080802090542.51052006.pj@sgi.com>
	<20080802142838.GA338@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008 18:28:38 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sat, Aug 02, 2008 at 09:05:42AM -0500, Paul Jackson wrote:
> > Alexey wrote:
> > > Folks might want to boot with NR_CPUS=4096 and see what happens,
> > > m->count games don't look promising. :-)
> > 
> > That comment is rather heavily dependent on the context of both:
> >  1) the previous patch comment, and
> >  2) booting and seeing.
> > 
> > Could you rewrite it, so that it doesn't depend on such context,
> > and can be read and understood, by itself?

I agree with Paul.  That changelog was useless, sorry.

> That's just a reminder to cpuset people whether /proc/*/status broken or
> not. Can be safely deleted. :-)

Deleting the changelog won't make it clearer (unlike some changelogs
which I've seen ;))

Please send a usable changleog for this patch, thanks.

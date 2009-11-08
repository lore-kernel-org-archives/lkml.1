Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZKHL5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZKHL5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZKHL5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:57:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48825 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbZKHL5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:57:30 -0500
Date: Sun, 8 Nov 2009 11:58:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alan Cox <alan@linux.intel.com>, mel@csn.ul.fi,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] slqb: A not quite so trivial warning
Message-ID: <20091108115849.24dc45a0@lxorguk.ukuu.org.uk>
In-Reply-To: <4AF6ADE1.60201@cs.helsinki.fi>
References: <20091106112942.14595.29799.stgit@localhost.localdomain>
	<4AF6ADE1.60201@cs.helsinki.fi>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Nov 2009 13:39:13 +0200
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Alan,
> 
> Alan Cox wrote:
> > mm/slqb.c:2773: warning: initialization from incompatible pointer type
> > 
> > Variable scope...
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> I don't see this warning in my tree. Is this coming from linux-next? Did 
> someone change DEFINE_PER_CPU not to prefix the variable name with 
> "per_cpu__"?

I see it from -next on an x86-32 build

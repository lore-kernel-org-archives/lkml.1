Return-Path: <linux-kernel-owner+w=401wt.eu-S1764525AbXJOGmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764525AbXJOGmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXJOGmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:42:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbXJOGmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:42:31 -0400
Date: Sun, 14 Oct 2007 23:41:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olaf Hering <olaf@aepfle.de>, linux-kernel@vger.kernel.org
Subject: Re: apm system does not power off anymore
Message-Id: <20071014234149.39a4f08a.akpm@linux-foundation.org>
In-Reply-To: <20071015163720.09630ee4.sfr@canb.auug.org.au>
References: <20071012125426.GA16626@aepfle.de>
	<20071014232316.4beb160f.akpm@linux-foundation.org>
	<20071015163720.09630ee4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 16:37:20 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> On Sun, 14 Oct 2007 23:23:16 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Also, it's bad that the operator has to provide some special boot command-line
> > option to make the machine work properly.  Please consider this to be a
> > bug.  Has it always needed apm=power-off?
> 
> It has always been that way because the behaviour of APM on SMP is not
> defined.  We discovered early that it will work (at least for powering
> off) for most SMP machines as long as the APM calls are done on CPU 0.
> However on an SMP machine that does not cope, very bad things happen -
> thus the operator has to explictly enable the power off behaviour on an
> SMP box.  (On UP power off is enabled by default.)

hrm, OK.

But it could have been controlled by a more-user-friendly runtime knob, I
guess.  Not that it's worth changing that now.


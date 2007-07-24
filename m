Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXGXJQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXGXJQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbXGXJQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:16:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758747AbXGXJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:16:38 -0400
Date: Tue, 24 Jul 2007 02:15:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Message-Id: <20070724021526.3d92286b.akpm@linux-foundation.org>
In-Reply-To: <46A5C12B.3080904@shadowen.org>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky>
	<46A534EA.6030008@intel.com>
	<46A5C12B.3080904@shadowen.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 10:06:51 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> > This is a royal pain, since it now throws an ERROR for the obviously
> > preferable piece of code below:
> > 
> > if (err) {
> >     do_something();
> >     return -ERR;
> > } else {
> >     do_somthing_else();
> > }
> 
> Hmmm, is that obviouly nicer than the below?  Its fully a line longer
> for no benefit.  But ignoring that, this seems to have snuck in to
> CodingStyle hmmm ... will see what I can do if anything to stop these
> being picked up I guess.
> 
> 	if (err) {
> 		do_something();
> 		return -ERR;
> 	} else
> 		do_something_else();

The kool kids on linux-usb-devel largely ended up deciding that the second
version looks dorky.

Especially if there's a comment over do_something_else(), and if there's
not a comment, perhaps there should be?

> Andrew, as you merged the change to CodingStyle I'll take that as your
> being ok with these being accepted.

It's very marginal and is sure to get people hot and bothered.  I'd suggest
that checkpatch be neutral on that.


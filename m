Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbXFWEGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbXFWEGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 00:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbXFWEGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 00:06:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbXFWEGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 00:06:39 -0400
Date: Fri, 22 Jun 2007 21:05:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: rdreier@cisco.com, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: scripts/checkpatch.pl refers to non-existent
 Documentation/Documentation/volatile-considered-harmful.txt
Message-Id: <20070622210559.6b9f7c30.akpm@linux-foundation.org>
In-Reply-To: <9a8748490706201403v1cee4467m78d143db86be02fc@mail.gmail.com>
References: <ada3b0m8hr0.fsf@cisco.com>
	<9a8748490706201403v1cee4467m78d143db86be02fc@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 20 Jun 2007 23:03:44 +0200 "Jesper Juhl" <jesper.juhl@gmail.com> wrote:
> On 20/06/07, Roland Dreier <rdreier@cisco.com> wrote:
> > Commit 4a0df2ef added the following to scripts/checkpatch.pl:
> >
> >     print "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n";
> >
> > but Linus's tree has no such file.  not sure what the right thing to
> > do here is, since I assume we do ultimately want something of the sort
> > in Documentation...
> >
> 
> That document is in the -mm kernel currently. As soon as it hits
> mainline from there checkpatch.pl will be right :-)
> 

oops.  I queued volatile-considered-harmful-take-3.patch for 2.6.22, thanks.

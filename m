Return-Path: <linux-kernel-owner+w=401wt.eu-S1763929AbXGXHH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763929AbXGXHH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbXGXHHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:07:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56839 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756130AbXGXHHN (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:07:13 -0400
Date: Tue, 24 Jul 2007 17:06:52 +1000
From: David Chinner <dgc@sgi.com>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, dgc@sgi.com
Subject: Re: fallocate() man page
Message-ID: <20070724070652.GX31489@sgi.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124601.GA22961@amitarora.in.ibm.com> <20070714082342.174830@gmx.net> <20070716053235.GA10945@amitarora.in.ibm.com> <46A44629.3090107@gmx.net> <20070723131039.GA29198@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723131039.GA29198@amitarora.in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 06:40:39PM +0530, Amit K. Arora wrote:
> On Mon, Jul 23, 2007 at 08:09:45AM +0200, Michael Kerrisk wrote:
> > I've taken the page that you sent and made various minor formatting and
> > wording fixes.  I've also added various FIXMEs to the page.  Some of these
> > ("FIXME .") are things that I need to check up later.  Some others are
> > questions for which I need input from you, David, or someone else with the
> > relevant info (I've marked these "FIXME Amit:").  Could you please review,
> > and send a new draft of the page back to me.
> 
> Thanks for going through the manpage and improving it!
> 
> My comments are below in between <Amit> ... </Amit> tags.

Does this Q&A really need to be encoded in nroff comments? ;)

> .\" FIXME Amit: I need author and license information for this page.
> .\" <Amit>
> .\"    David Chinner is the original author, hence he can help with this.
> .\" </Amit>

Patch below.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

diff -u orig/fallocate.3 new/fallocate.3
--- orig/fallocate.3	Tue Jul 24 17:00:42 2007
+++ new/fallocate.3	Tue Jul 24 17:02:44 2007
@@ -1,7 +1,6 @@
-.\" FIXME Amit: I need author and license information for this page.
-.\" <Amit>
-.\"    David Chinner is the original author, hence he can help with this.
-.\" </Amit>
+.\" Copyright (c) 2007 Silicon Graphics, Inc. All Rights Reserved
+.\" Written by Dave Chinner <dgc@sgi.com>
+.\" May be distributed as per GPLv2
 .TH FALLOCATE 2 2007-07-20 "Linux" "Linux Programmer's Manual"
 .SH NAME
 fallocate \- manipulate file space

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbYARPz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbYARPz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbYARPzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:55:47 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:51279 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbYARPzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:55:46 -0500
Date: Fri, 18 Jan 2008 10:55:41 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Francis Moreau <francis.moro@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Why not creating a GIT RT tree ?
In-Reply-To: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0801180947180.7574@gandalf.stny.rr.com>
References: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Jan 2008, Francis Moreau wrote:

> Maybe I missed it but I'm wondering why GIT is not used for
> the RT development ? I can't find a rt tree anywhere and all
> new rt release spoke about a patchset to apply on mainline
> kernels.

The answer to this is pretty much the same as why the -mm tree isn't in
git either.

The RT tree is made up of lots of patches (over 300). Our goal is to get
RT into mainline Linux. RT isn't just one type of system, it extends all
over the kernel, and the patches may be rewriten over and over. Managing
this in quilt is a lot easier than managing it in git.

That said, there's been talk about making a git tree for others based on
the quilt queue. The thing is that a new git tree will need to be created
for every release. Which means that it will be difficult for others to
simply update their local repo since you will get a bunch of errors with
not being from the same head.


>
> Another question, is there a TODO list somewhere which would
> help to port the RT patch to a new architecture ?

Which arch? We are already on PowerPC, ARM and MIPS. Thinking about sh?

The best would be to read the code and look at my paper:

http://ols.108.redhat.com/2007/Reprints/rostedt-Reprint.pdf
(Internals of the RT Patch)

This will give you an idea of what is needed to port to another arch.

>
> Sorry if the questions are dumbed but I'm just new to this
> project.

No, in fact, I think it's about time to add these to our FAQ:

http://rt.wiki.kernel.org/index.php/Frequently_Asked_Questions

Thanks,

-- Steve


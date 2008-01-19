Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYASUfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYASUfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 15:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYASUfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 15:35:15 -0500
Received: from po-out-1718.google.com ([72.14.252.159]:50384 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYASUfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 15:35:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=scA9Kza6oMQa2zE82mwIQnikIlORljf8BY10U01mS7sV6F2FkxbERhUwQd0dg3SCd32/hbNvBw/JQ1BGhLaJMHzIXgzHokLuxRnboWKg2EBvEAs16x9aKCGbuLyyT6j5kylylJZcxeOoMEhCylpcWScT0sRAghERLKLTbAz9h20=
Message-ID: <9e4733910801191235k5ccd247cka2f6bf2a10dbd3a4@mail.gmail.com>
Date: Sat, 19 Jan 2008 15:35:12 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: Why not creating a GIT RT tree ?
Cc: "Francis Moreau" <francis.moro@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0801180947180.7574@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801180544j2022af8bl252a118a295b1f34@mail.gmail.com>
	 <Pine.LNX.4.58.0801180947180.7574@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/18/08, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 18 Jan 2008, Francis Moreau wrote:
>
> > Maybe I missed it but I'm wondering why GIT is not used for
> > the RT development ? I can't find a rt tree anywhere and all
> > new rt release spoke about a patchset to apply on mainline
> > kernels.
>
> The answer to this is pretty much the same as why the -mm tree isn't in
> git either.
>
> The RT tree is made up of lots of patches (over 300). Our goal is to get
> RT into mainline Linux. RT isn't just one type of system, it extends all
> over the kernel, and the patches may be rewriten over and over. Managing
> this in quilt is a lot easier than managing it in git.
>
> That said, there's been talk about making a git tree for others based on
> the quilt queue. The thing is that a new git tree will need to be created
> for every release. Which means that it will be difficult for others to
> simply update their local repo since you will get a bunch of errors with
> not being from the same head.

stgit is worth checking out. It's basically quilt for git. I'm using
to juggle about 30 patches.

I believe there is a way to set up the git config file on the server
to force updating clients onto the new head without triggering an
error messages.

Ask on the git list and you'll get at least a dozen different
suggestions on how to make your repo available on git.

>
>
> >
> > Another question, is there a TODO list somewhere which would
> > help to port the RT patch to a new architecture ?
>
> Which arch? We are already on PowerPC, ARM and MIPS. Thinking about sh?
>
> The best would be to read the code and look at my paper:
>
> http://ols.108.redhat.com/2007/Reprints/rostedt-Reprint.pdf
> (Internals of the RT Patch)
>
> This will give you an idea of what is needed to port to another arch.
>
> >
> > Sorry if the questions are dumbed but I'm just new to this
> > project.
>
> No, in fact, I think it's about time to add these to our FAQ:
>
> http://rt.wiki.kernel.org/index.php/Frequently_Asked_Questions
>
> Thanks,
>
> -- Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Jon Smirl
jonsmirl@gmail.com

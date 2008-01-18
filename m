Return-Path: <linux-kernel-owner+w=401wt.eu-S1764345AbYARRhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764345AbYARRhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762287AbYARRh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:37:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:59252 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760191AbYARRhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:37:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nSP0ZdLf7AEORjf4wFiBCRJwXTpuooEiaPwjrAxZ2LN1GjXcKskdBaSvfKVA9MzzL7KMZeL0NhGsgylEHIOB1sID5GMzbHHyHsqge2HgsW9HMS4JyPR057Kn5nH/Qf71SxEDZ2oZTPztLH9bkwEMICjsJLe1lDC9abv9JOMb0nc=
Message-ID: <38b2ab8a0801180937y4264fc15wd3b91ca74635f679@mail.gmail.com>
Date: Fri, 18 Jan 2008 18:37:24 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: Why not creating a GIT RT tree ?
Cc: linux-kernel@vger.kernel.org
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

Hello,

On Jan 18, 2008 4:55 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
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

Well not exactly. Unlike the mm tree which is made of a lots of patches
dealing with totaly unrelated subjects, the rt patches only hopefully deal
with realtime stuffs.

> The RT tree is made up of lots of patches (over 300). Our goal is to get
> RT into mainline Linux. RT isn't just one type of system, it extends all
> over the kernel, and the patches may be rewriten over and over. Managing
> this in quilt is a lot easier than managing it in git.
>

I'm probably missing something since I haven't looked at the RT patches
(yet) but couldn't these 300 patches be sorted out by topics ?

If so you could create a branch per topic and merge all of them in your
master branch which would be the rt kernel. Hopefully each branch
won't interact with other branch too much.

All of this assumes of course that the number of topics is definitely much
smaller than the number of patches (~300).

Having such a tree would be very useful for looking at history in each topic,
for doing some git-bisect debug session IMHO...

> That said, there's been talk about making a git tree for others based on
> the quilt queue. The thing is that a new git tree will need to be created
> for every release. Which means that it will be difficult for others to
> simply update their local repo since you will get a bunch of errors with
> not being from the same head.
>
>
> >
> > Another question, is there a TODO list somewhere which would
> > help to port the RT patch to a new architecture ?
>
> Which arch? We are already on PowerPC, ARM and MIPS. Thinking about sh?
>

Yep, not that I'm an expert in this architecture but it's commonly used
in multimedia device where realtime is often needed.

Thanks
-- 
Francis

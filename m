Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYFFSI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYFFSI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 14:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYFFSIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 14:08:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:38644 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbYFFSIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 14:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QJk8i8Yimgj3k2mkeGxS+6X4A5zAv6NaUjUw9R3a5M2GlFn8sVZqhUb4uBHqgdMYKy
         +CSu9xZHYzQA+5RW4l902jvr8U9RL7N3YlGlcsRz7phnCTEljt+VKaTPItkWT34KcVcC
         KDyBXw2d92jSPW3H4gR+e5ZcNpRI6WWUHORWA=
Message-ID: <31e679430806061108h1b6de210ja8ef85cd315a88be@mail.gmail.com>
Date: Fri, 6 Jun 2008 21:08:43 +0300
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "yoann padioleau" <yoann.padioleau@gmail.com>
Subject: Re: Full git history of Linux
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <390282f40806060850v106f8defid2694dade6ba2135@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <390282f40806060850v106f8defid2694dade6ba2135@mail.gmail.com>
X-Google-Sender-Auth: 4cb06fb8292178f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 6, 2008 at 6:50 PM, yoann padioleau
<yoann.padioleau@gmail.com> wrote:
> Hi,
>
> If anyone is interested, I have put on my website[1] a git repository
> containing the full history of Linux, from 0.01 to now.
> It's built from 3 other git repositories:
>  - the one from Dave Jones from 0.01 to 2.4.0,
>  - the one from tglx from 2.4.0 to 2.6.12,
>  - the one from Linus Torvalds from 2.6.12 to now.
>
> I used the "graft" feature of git (thanks to Junio and people
> on #git for the tip) to link them together. I also modified
> (via a git-filter-branch) the dates of some commits as for
> instance all commits from the Dave Jones's repo had the
> same date (23 Nov 2007). For this I mainly used the timestamp info
> of files on kernel.org. The script and info I used are also
> available on my website[2].
>
> Note that because I used the graft feature, this repo is
> really just a superset of the one from Torvalds so you can
> pull as you would do with the Torvalds repo to get the
> latest Linux version.
>
> The reason why I built this repo is that I wanted to study
> the history of source code comments in Linux and git annotate
> could answer most of my questions automatically. For instance
> I wanted to know what comments were written before 1995 that are
> still present unmodified in the current Linux version.
> But for git annotate to work I needed a git repo with the
> full history of Linux. Other people may find my repo useful for other
> purpose.
>
> [1] full git repo:
>    http://aryx.kicks-ass.org/~pad/linux/full-history-linux.git.tar
>    Then untar it and do a git checkout -f  to populate it
>
>
> [2] script to build the git repo from scratch:
>    http://aryx.kicks-ass.org/~pad/linux/make-full-linux-history.tgz
>    Then untar it; make; ./make-full-kernel-history full
>    Note: you will need to install OCaml first.
>
> PS: Is there a way to put it on kernel.org?
>
> PS2: Some commits have only an approximate date. It was good
> enough for what I wanted. If you want more precise date, tell
> me, the script is easy to modify.

That's great :-)
I already got my copy and I'll try to use it to study linux evolution
over the years :-)

really good

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net

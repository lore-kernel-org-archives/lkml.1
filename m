Return-Path: <linux-kernel-owner+w=401wt.eu-S1764253AbYFFPvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764253AbYFFPvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763442AbYFFPuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:50:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:64733 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763417AbYFFPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=DjrScXUbVdbg9FPsWBeB36v2sHlnRM1DHMCBVZE4nJuux1kFccgpdutSEoJPYhowXQ
         kzFoeli1pdO6KDxEdVbQNj4dH0KPqkCxvRCZepEyGvFugq3j9OvS5/ClJXYI0DXSmZBL
         FhUv3MjYoakzwY6eyWFbgqzj7YWpUsEcORULw=
Message-ID: <390282f40806060850v106f8defid2694dade6ba2135@mail.gmail.com>
Date: Fri, 6 Jun 2008 10:50:48 -0500
From: "yoann padioleau" <yoann.padioleau@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Full git history of Linux
Cc: kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If anyone is interested, I have put on my website[1] a git repository
containing the full history of Linux, from 0.01 to now.
It's built from 3 other git repositories:
 - the one from Dave Jones from 0.01 to 2.4.0,
 - the one from tglx from 2.4.0 to 2.6.12,
 - the one from Linus Torvalds from 2.6.12 to now.

I used the "graft" feature of git (thanks to Junio and people
on #git for the tip) to link them together. I also modified
(via a git-filter-branch) the dates of some commits as for
instance all commits from the Dave Jones's repo had the
same date (23 Nov 2007). For this I mainly used the timestamp info
of files on kernel.org. The script and info I used are also
available on my website[2].

Note that because I used the graft feature, this repo is
really just a superset of the one from Torvalds so you can
pull as you would do with the Torvalds repo to get the
latest Linux version.

The reason why I built this repo is that I wanted to study
the history of source code comments in Linux and git annotate
could answer most of my questions automatically. For instance
I wanted to know what comments were written before 1995 that are
still present unmodified in the current Linux version.
But for git annotate to work I needed a git repo with the
full history of Linux. Other people may find my repo useful for other
purpose.

[1] full git repo:
    http://aryx.kicks-ass.org/~pad/linux/full-history-linux.git.tar
    Then untar it and do a git checkout -f  to populate it


[2] script to build the git repo from scratch:
    http://aryx.kicks-ass.org/~pad/linux/make-full-linux-history.tgz
    Then untar it; make; ./make-full-kernel-history full
    Note: you will need to install OCaml first.

PS: Is there a way to put it on kernel.org?

PS2: Some commits have only an approximate date. It was good
enough for what I wanted. If you want more precise date, tell
me, the script is easy to modify.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbZDQVqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbZDQVqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZDQVqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:46:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754846AbZDQVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:46:08 -0400
Date: Fri, 17 Apr 2009 14:41:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
Message-Id: <20090417144117.4ac8828f.akpm@linux-foundation.org>
In-Reply-To: <1240003652.31116.44.camel@localhost>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	<20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	<1240003652.31116.44.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 14:27:32 -0700
Joe Perches <joe@perches.com> wrote:

> $ ./scripts/get_maintainer.pl -f Documentation/DocBook/sh.tmpl 

Lots of people's scripts/get_maintainer.pl files won't have the `x' bit
set because patch(1) is dumb.  So for reliability it's best to always do

	perl ./scripts/get_maintainer.pl

<does that>

: akpm:/usr/src/25> perl scripts/get_maintainer.pl -f fs/ext3/inode.c 
: grep: The -P option is not supported

    that's odd.  `man grep' on this machine says

    -P, --perl-regexp
          Interpret PATTERN as a Perl regular expression.

: fatal: Not a git repository

    it whines about not being run in a git directory, but does a decent
    job anyway.  

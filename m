Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbZDQWzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbZDQWzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZDQWzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:55:40 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1391 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZDQWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:55:40 -0400
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: randy.dunlap@oracle.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090417151853.6f02d8d3.akpm@linux-foundation.org>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	 <1240003652.31116.44.camel@localhost>
	 <20090417144117.4ac8828f.akpm@linux-foundation.org>
	 <1240006168.31116.62.camel@localhost>
	 <20090417151853.6f02d8d3.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 15:53:49 -0700
Message-Id: <1240008829.31116.74.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 15:18 -0700, Andrew Morton wrote:
> On Fri, 17 Apr 2009 15:09:28 -0700
> Joe Perches <joe@perches.com> wrote:
> > I changed the script to verify that a .git directory
> > exists before running git.
> 
> hm, well, there's benefit in telling the user "hey, you'll get better
> results if you run this in your git directory".

OK, I'll add the message

+    if (!(-d ".git")) {
+	warn("$P: .git repository not found.\n");
+	warn("Use a .git repository for better results.\n");
+	warn("ie: git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git\n");
+	return;
+    }

when I submit the patches.

cheers, Joe


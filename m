Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZJ0AIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZJ0AIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZJ0AIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:08:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1074 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbZJ0AIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:08:43 -0400
Subject: git vs hg commit counts?
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: git <git@vger.kernel.org>, mercurial@selenic.com,
       Marti Raudsepp <marti@juffo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 17:08:47 -0700
Message-ID: <1256602127.29938.8.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm comparing linux-kernel git vs hg repositories.

While testing some changes to scripts/get_maintainer.pl,
I noticed that git and hg have different commit counts
for the same files.

For instance:

$ git log --since=1-year-ago -- MAINTAINERS | \
	grep -P "^commit [0-9a-f]{40,40}$"  | wc -l
514

$ hg log --template="commit {node}\n" --date -365 -- MAINTAINERS  | \
	grep -P "^commit [0-9a-f]{40,40}$" | wc -l
601

Anyone have any understanding why?


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZEYMzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZEYMzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZEYMzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:55:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbZEYMzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:55:37 -0400
Date: Mon, 25 May 2009 14:55:35 +0200
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] kbuild: some scripts/config improvements
Message-ID: <20090525125535.GA12943@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are some patches to make scripts/config more usable (we have a
similar script in our kernel spec files, if these patches get merged, we
can drop it and use scripts/config instead).

Michal Marek (3):
  kbuild: handle non-existing options in scripts/config
  kbuild: simplify argument loop in scripts/config
  kbuild: add generic --set option to scripts/config

 scripts/config |  108 ++++++++++++++++++++++++++++++++------------------------
 1 files changed, 62 insertions(+), 46 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZEYOnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZEYOnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZEYOnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:43:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZEYOnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:43:22 -0400
Date: Mon, 25 May 2009 16:43:20 +0200
From: Michal Marek <mmarek@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] kbuild: some scripts/config improvements (try 2)
Message-ID: <20090525144320.GA22686@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I simplified the awk script a bit, made it awk ... && mv and removed the
--set option.

Michal Marek (3):
  kbuild: handle non-existing options in scripts/config
  kbuild: simplify argument loop in scripts/config
  kbuild: add generic --set-str option to scripts/config

 scripts/config |   97 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 51 insertions(+), 46 deletions(-)

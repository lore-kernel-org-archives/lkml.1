Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbZDXHQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbZDXHQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZDXHQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:16:42 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1608 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbZDXHQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:16:41 -0400
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090422203005.GA467@elf.ucw.cz>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	 <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz>
	 <1240415689.21848.19.camel@localhost>
	 <20090422185916.GA3864@uranus.ravnborg.org>
	 <20090422120510.cc17e470.akpm@linux-foundation.org>
	 <1240430185.21848.103.camel@localhost>  <20090422203005.GA467@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 00:13:53 -0700
Message-Id: <1240557233.6735.240.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 22:30 +0200, Pavel Machek wrote:
> If possible, it would be nice to aggregate multiple entries onto one
> line. I.e.:
> P:      Len Brown
> M:      len.brown@intel.com
> P:      Pavel Machek
> M:      pavel@ucw.cz
> P:      Rafael J. Wysocki
> M:      rjw@sisk.pl
> L:      linux-pm@lists.linux-foundation.org
> S:      Supported
> 
> ->
> 
> P:      Len Brown now <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Rafael J. Wysocki <rjw@sisk.pl>
> L:      linux-pm@lists.linux-foundation.org
> S:      Supported

I changed:

the script to support all 3 styles

	P:	name
	M:	address
or
	M:	name <address>
or
	M:	name1 <address1>, name2 <address2>

and made a few other changes to MAINTAINERS and the script.
You can pull it as below.

Let me know if it works for you.

The following changes since commit 091069740304c979f957ceacec39c461d0192158:
  Linus Torvalds (1):
        Linux 2.6.30-rc3

are available in the git repository at:

  git://repo.or.cz/linux-2.6/trivial-mods.git gm_20090423

Joe Perches (13):
      scripts/get_maintainer.pl - Output first field only in mailing lists and after maintainers.
      scripts/get_maintainer.pl - Better fix for subscriber-only mailing lists
      scripts/get_maintainer.pl - improve --git-chief-penquins (Linus Torvalds) filtering
      scripts/get_maintainer.pl - Warn on missing git or git repository
      scripts/get_maintainer.pl - support M: lines with names and multiple entries per M: line
      scripts/get_maintainer.pl - Better email name quoting
      scripts/get_maintainer.pl - Support both "P:/M:" and integrated "M:" lines
      MAINTAINERS - Add file patterns to "THE REST"
      MAINTAINERS - Update M32R file patterns after rename
      MAINTAINERS - Mark ALSA lists as moderated
      MAINTAINERS - Combine P: and M: entries
      MAINTAINERS - Combine multiple M: lines
      scripts/get_maintainer.pl - Don't print maintainers when not requested

 MAINTAINERS               | 2472 +++++++++++++--------------------------------
 scripts/get_maintainer.pl |  232 ++++-
 2 files changed, 907 insertions(+), 1797 deletions(-)



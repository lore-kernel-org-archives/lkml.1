Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbZEDLzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbZEDLzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZEDLzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:55:32 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:56916 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbZEDLzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:55:32 -0400
Date: Mon, 4 May 2009 13:57:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sean MacLennan <smaclennan@pikatech.com>, Anders Kaseorg <andersk@mit.edu>,
       Jean Delvare <khali@linux-fr.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>, Wolfgang Denk <wd@denx.de>
Subject: kbuild, modpost: fix "non-allocatable section" warnings
Message-ID: <20090504115704.GA7134@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turned out there were at least three sources of
the "non-allocatable section" warning.

1) SUSE specific .comment section
2) endianness issues in elf header
3) additional debug sections

I have updated kbuild-fixes.git with
patches for all of the above.

But as we have seen three independent sources of this
warning within short time I expect there may be
yet-to-be-discovered issues.

The patches accumulated so far all looks trivially correct
and Jean and Sean has been quick to test them.
So unless something unexpected shows up I plan to push them
within a day or two.

I would like to see them in -next for a day or two first
in the hope that if other architectures has troubles
they will report this before it hits upstream.

Patches will follow for reference / testing.

	Sam

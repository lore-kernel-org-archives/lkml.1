Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbYDZOXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbYDZOXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYDZOWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:22:51 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:36217 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751602AbYDZOWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:22:50 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 27 Apr 2008 00:22:35 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Sam Ravnborg <sam@ravnborg.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kbuild@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in	header file
Message-ID: <20080426142235.GB7051@tull.net>
References: <20080426134554.GA20727@damson.getinternet.no> <48133537.7040800@cs.helsinki.fi> <19f34abd0804260717le1773aapec49cdb6f68e296f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0804260717le1773aapec49cdb6f68e296f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 04:17:15PM +0200, Vegard Nossum wrote:
> I didn't want to get into the lands of parsing options since we would
> need to handle gcc options and skip arguments to those, etc.

?

use Getopt::Std qw(getopts);

use vars qw($opt_g);

getopts('g');

[...]

if ($opt_g) {
	graph();
}

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7

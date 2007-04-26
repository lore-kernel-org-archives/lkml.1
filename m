Return-Path: <linux-kernel-owner+w=401wt.eu-S1423471AbXDZAkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423471AbXDZAkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423474AbXDZAkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:40:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423471AbXDZAkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:40:13 -0400
Date: Wed, 25 Apr 2007 20:39:11 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, mb@bu3sch.de,
       linville@tuxdriver.com, arnd@arndb.de, maxextreme@gmail.com,
       gregkh@suse.de
Subject: Re: [PATCH 0/9] Kconfig: cleanup s390 v2.
Message-ID: <20070426003911.GA19383@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	mb@bu3sch.de, linville@tuxdriver.com, arnd@arndb.de,
	maxextreme@gmail.com, gregkh@suse.de
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org> <20070425112133.4ae86399.randy.dunlap@oracle.com> <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425172447.1576c399.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 05:24:47PM -0700, Andrew Morton wrote:

 > It would be neat if someone could create and maintain a new
 > scripts/spot-common-mistakes.  Feed it a unified diff and it would complain
 > about newly-added code (and only newly-added code) which has busted
 > whitespace, adds new semaphores, adds new kernel_thread calls, etc, etc.

years and years ago, when the dinosaurs roamed the land, I hacked up..
http://janitor.kernelnewbies.org/scripts/  and then left it by the wayside.
Some of the checks it did are actually bogus, but I'm happy to pick that
up again if there's interest in it being a useful tool.

In fact, I should probably munge it together with a similar thing
I wrote at http://www.codemonkey.org.uk/projects/findbugs/
(Warning: scary regexps)

 > It would need to be fairly simple and easily-extensible, as I can
 > imagine quite a few things getting added to it.
 > 
 > (Imagines a procmail rule which just bounces the email if
 > spot-common-mistakes failed)

or a git checkin rule that refuses to commit if it fails ;-)

	Dave

-- 
http://www.codemonkey.org.uk

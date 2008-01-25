Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbYAYW0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbYAYW0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYAYWZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:25:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48162 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbYAYWZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:25:56 -0500
Date: Fri, 25 Jan 2008 23:25:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 183/196] driver core: fix build with SYSFS=n
Message-ID: <20080125222530.GA23769@elte.hu>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-104-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201246425-5058-104-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg Kroah-Hartman <gregkh@suse.de> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When SYSFS=n and MODULES=y, build ends with:
> 
> linux-2.6.24-rc6-mm1/drivers/base/module.c: In function 'module_add_driver':
> linux-2.6.24-rc6-mm1/drivers/base/module.c:49: error: 'module_kset' undeclared (first use in this function)
> make[3]: *** [drivers/base/module.o] Error 1

_PLEASE_ fold such fixes into the patch that introduces the build bugs, 
prior sending your git trees upstream! (just like Andrew does it with 
all patches that come via -mm)

Changes like this (and it now leaked into Linus' tree as well) kill 
bisectability.

Thanks.

	Ingo

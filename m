Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZLGHjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZLGHjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758623AbZLGHjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:39:13 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60409 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647AbZLGHjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:39:13 -0500
Date: Mon, 7 Dec 2009 13:09:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Miloslav Trmac <mitr@redhat.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v2 2/4] copy_signal cleanup: clean acct_init_pacct() and
 taskstats_tgid_init()
Message-ID: <20091207073914.GE5780@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091201221036.GA10052@darkmag.usersys.redhat.com>
 <20091202135759.GA791@redhat.com>
 <20091204142901.GI10052@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091204142901.GI10052@darkmag.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Veaceslav Falico <vfalico@redhat.com> [2009-12-04 15:29:01]:

> Remove unneeded initializations in acct_init_pacct() and taskstats_tgid_init().
> These are accessed only via copy_signal() and are useless after using
> kmem_cache_zalloc() in copy_signal().
> 
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

As Oleg suggested, please reorder the cleanup to remove the empty
functions.

-- 
	Balbir

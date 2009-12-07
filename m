Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbZLGHe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbZLGHe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbZLGHe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:34:58 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57205 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171AbZLGHe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:34:57 -0500
Date: Mon, 7 Dec 2009 13:04:55 +0530
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
Subject: Re: [PATCH v2 1/4] copy_signal cleanup: use zalloc and remove
 initializations
Message-ID: <20091207073454.GD5780@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091201221036.GA10052@darkmag.usersys.redhat.com>
 <20091202135759.GA791@redhat.com>
 <20091204142814.GH10052@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091204142814.GH10052@darkmag.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Veaceslav Falico <vfalico@redhat.com> [2009-12-04 15:28:14]:

> Use kmem_cache_zalloc() on signal creation and remove unneeded initialization
> lines in copy_signal().
> 
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

Good cleanup, thanks!

-- 
	Balbir

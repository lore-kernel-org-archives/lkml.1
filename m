Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZLHMiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZLHMiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZLHMiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:38:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447AbZLHMiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:38:08 -0500
Date: Tue, 8 Dec 2009 13:37:05 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Miloslav Trmac <mitr@redhat.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v2 1/4] copy_signal cleanup: use zalloc and remove
	initializations
Message-ID: <20091208123705.GB28338@darkmag.usersys.redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com> <20091204142814.GH10052@darkmag.usersys.redhat.com> <20091207123615.fc841a83.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207123615.fc841a83.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 12:36:15PM -0800, Andrew Morton wrote:
> 
> For some reason this patch is missing its headers and doesn't apply.
> 

I'm really sorry, but I don't really understand what is wrong with them
and why they don't apply :(. Could you please help me with that?

>
> I fixed that up and it still doesn't apply, because there are pending
> changes in this area in -mm.
> 
> Normally I'd fix that up, but this one is looking a bit non-trivial, so
> I'm afraid I'm going to ask you to redo the patches against
> http://userweb.kernel.org/~akpm/mmotm/
>

Thank you, will redo the patchset against -mm shortly.

--
Veaceslav 

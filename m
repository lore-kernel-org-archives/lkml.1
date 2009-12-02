Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZLBS2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZLBS2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZLBS2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:28:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbZLBS2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:28:47 -0500
Date: Wed, 2 Dec 2009 19:27:58 +0100
From: Veaceslav Falico <vfalico@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Miloslav Trmac <mitr@redhat.com>,
       James Morris <jmorris@namei.org>, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 1/4] copy_signal cleanup: use zalloc and remove
	initializations
Message-ID: <20091202182758.GG10052@darkmag.usersys.redhat.com>
References: <20091201221036.GA10052@darkmag.usersys.redhat.com> <20091202135759.GA791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202135759.GA791@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 02:57:59PM +0100, Oleg Nesterov wrote:
> 
> Personally I don't mind, but perhaps it is better to move this change
> into 3/4 which changes thread_group_cputime_init().
> 

Thank you for your review. I'll repost the fixed patchset tommorow.

--
Veaceslav 

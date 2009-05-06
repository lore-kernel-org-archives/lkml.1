Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbZEFUKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbZEFUKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZEFUJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:09:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZEFUJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:09:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to simplify
	do_wait() pathes
In-Reply-To: Oleg Nesterov's message of  Wednesday, 6 May 2009 07:33:24 +0200 <20090506053324.GA31988@redhat.com>
References: <20090506053324.GA31988@redhat.com>
X-Zippy-Says: A GRAM??  A BRAM...  A GROOM...  A BROOM...  Oh, Yeh!!  Wash the ROOM!!
Message-Id: <20090506200949.4FF6CFC39E@magilla.sf.frob.com>
Date: Wed,  6 May 2009 13:09:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like the idea just fine.  Drop the "w" on every field name.
If you want them to have a greppable uniqueness/prefix, use "wo_".
I'd go with a shorter name for the canonical pointer parameter,
like "w" or "wo".

It looks cleaner to me to keep the several args to do_wait() and have
it use a single initializer with = { .foo = a, .bar = b } syntax there.


Thanks,
Roland

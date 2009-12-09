Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbZLITGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbZLITGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbZLITGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:06:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470AbZLITGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:06:09 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       guijianfeng@cn.fujitsu.com
Subject: Re: [PATCH 2/2] cfq-iosched: Take care of corner cases of group losing share due to deletion
References: <1260312778-4725-1-git-send-email-vgoyal@redhat.com>
	<1260312778-4725-2-git-send-email-vgoyal@redhat.com>
	<20091209135639.GW8742@kernel.dk> <20091209151723.GA8452@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 09 Dec 2009 14:06:10 -0500
In-Reply-To: <20091209151723.GA8452@redhat.com> (Vivek Goyal's message of
	"Wed, 9 Dec 2009 10:17:23 -0500")
Message-ID: <x49bpi8nf19.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Reported-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

> +	/*
> +	 * If think times is less than a jiffy than ttime_mean=0 and above
> +	 * will not be true. It might happen that slice has not expired yet
> +	 * but will expire soon (4-5 ns) during select_queue(). To cover the

4-5ns?  I'm not sure why you chose these numbers.  Is that what you saw
in testing?  Anyway, I'm ok with the change, I dislike the reference to
time when a single jiffy could be up to 10ms.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

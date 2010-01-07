Return-Path: <linux-kernel-owner+w=401wt.eu-S932900Ab0AGJY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab0AGJY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976Ab0AGJYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:24:24 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:60336 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab0AGJYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:24:22 -0500
Date: Thu, 7 Jan 2010 10:24:18 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] S390: use helpers for rlimits
Message-ID: <20100107102418.356be58c@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1262791479-26594-4-git-send-email-jslaby@suse.cz>
References: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
	<1262791479-26594-4-git-send-email-jslaby@suse.cz>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Jan 2010 16:24:32 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> Make sure compiler won't do weird things with limits. E.g. fetching
> them twice may return 2 different values after writable limits are
> implemented.
> 
> I.e. either use rlimit helpers added in
> 3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
> or ACCESS_ONCE if not applicable.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org
> ---

Added to the git390 queue. Thanks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


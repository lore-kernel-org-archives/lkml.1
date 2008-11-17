Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYKQJqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYKQJqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYKQJqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:46:21 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:54675 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYKQJqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:46:21 -0500
Date: Mon, 17 Nov 2008 10:46:18 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] stop_machine: fix race with return value (fixes Bug
	#11989)
Message-ID: <20081117094618.GA4296@osiris.boeblingen.de.ibm.com>
References: <200811170822.18880.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811170822.18880.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 08:22:18AM +1030, Rusty Russell wrote:
> Bug #11989: Suspend failure on NForce4-based boards due to chanes in stop_machine
> 
> We should not access active.fnret outside the lock; in theory the next
> stop_machine could overwrite it.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Tested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
>  kernel/stop_machine.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Thank you, Rusty, for finding and fixing this one as well!

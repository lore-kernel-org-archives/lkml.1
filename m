Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYHSWQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYHSWQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbYHSWQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:16:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50514 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757365AbYHSWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:16:24 -0400
Date: Tue, 19 Aug 2008 22:58:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 06/10] ldisc n_tty: export all N_TTY ldisc methods.
Message-ID: <20080819225808.05c96802@lxorguk.ukuu.org.uk>
In-Reply-To: <1219182612-13814-7-git-send-email-giometti@linux.it>
References: <1219182612-13814-1-git-send-email-giometti@linux.it>
	<1219182612-13814-2-git-send-email-giometti@linux.it>
	<1219182612-13814-3-git-send-email-giometti@linux.it>
	<1219182612-13814-4-git-send-email-giometti@linux.it>
	<1219182612-13814-5-git-send-email-giometti@linux.it>
	<1219182612-13814-6-git-send-email-giometti@linux.it>
	<1219182612-13814-7-git-send-email-giometti@linux.it>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 23:50:08 +0200
Rodolfo Giometti <giometti@linux.it> wrote:

> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> ---
>  drivers/char/n_tty.c |   54 +++++++++++++++++++++++++++++--------------------
>  include/linux/tty.h  |   16 ++++++++++++++
>  2 files changed, 48 insertions(+), 22 deletions(-)

Renames are really not part of the same change set but very sensible so
no objection. EXPORT_SYMBOL_GPL please - pps is (with permission)
sticking its nose into the innards of n_tty. Those are not good general
interfaces however.



With the small changes noted I'm happy for the tty stuff to go upstream.

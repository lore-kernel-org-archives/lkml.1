Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbYIZKNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbYIZKNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYIZKNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:13:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48321 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138AbYIZKNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:13:02 -0400
Date: Fri, 26 Sep 2008 11:13:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lin Tan <tammy000@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH git latest] drivers/scsi: fixing wrong comment before
 new_buffer_tape()
Message-ID: <20080926111300.1dd34009@lxorguk.ukuu.org.uk>
In-Reply-To: <20080925174948.GA14180@carmen.cs.uiuc.edu>
References: <20080925174948.GA14180@carmen.cs.uiuc.edu>
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

On Thu, 25 Sep 2008 12:49:48 -0500
Lin Tan <tammy000@gmail.com> wrote:

> (I would wish to be personally CC'ed the answers/comments posted to the list in response to my posting.)
> 
> ---
> 
> Removing the wrong comment.
> The lock is needed before calling new_tape_buffer(), at least in some cases.
> So the comment above new_tape_buffer() is inconsistent with the code and
> may mislead developers.
> 
> I simply removed the wrong comment, as I am not sure if the lock is required
> in all situations. If so, we should add "Caller must hold os_scsi_tapes_lock".
> 
> Signed-off-by: Lin Tan <tammy000@gmail.com>

Looks true to me for the current versions of the code. In fact it is only
ever called from the initialisation function that I can see so chunks of
the code could simply go away as well as bits of the comment. Ditto the
one in drivers/scsi/st.c

Acked-by: Alan Cox <alan@redhat.com>


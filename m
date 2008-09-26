Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbYIZQJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbYIZQJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 12:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYIZQJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 12:09:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45350 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983AbYIZQJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 12:09:38 -0400
Date: Fri, 26 Sep 2008 17:09:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH git latest] drivers/scsi: fixing wrong comment before
 new_buffer_tape()
Message-ID: <20080926170937.2983fc29@lxorguk.ukuu.org.uk>
In-Reply-To: <7fcc02550809260905oa17880fi80c94eaacb33dba3@mail.gmail.com>
References: <20080925174948.GA14180@carmen.cs.uiuc.edu>
	<20080926111300.1dd34009@lxorguk.ukuu.org.uk>
	<7fcc02550809260905oa17880fi80c94eaacb33dba3@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Looks true to me for the current versions of the code. In fact it is only
> > ever called from the initialisation function that I can see so chunks of
> > the code could simply go away as well as bits of the comment. Ditto the
> > one in drivers/scsi/st.c
> >
> > Acked-by: Alan Cox <alan@redhat.com>
> >
> 
> I am sorry I didn't quite understand. You mean it is true that caller
> must hold os_scsi_tapes_lock?

Sorry - I mean what you claim is true - that the comment is incorrect.

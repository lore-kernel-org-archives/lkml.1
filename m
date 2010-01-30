Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836Ab0A3EI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab0A3EI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 23:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477Ab0A3EI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 23:08:59 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:62524 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0A3EI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 23:08:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KlylodORl/5iZRgMhkiUSA9xrk1Yz1QCpB9hGQDEwFbKqmcc2mKUHZlD/WDQrFF7EZ
         +A1YONcdAz+sbA6m7025s8VUaKkDrspIA0kN49FnL+CPaJJbFJC+gx3LzSOVQC9XV3pM
         yf1UV/mL/Do+oEbyF5chBuYkj/Re+NTqx9EwM=
MIME-Version: 1.0
Date: Fri, 29 Jan 2010 22:08:57 -0600
Message-ID: <524f69651001292008g39c796a7j6f41c04b599752c7@mail.gmail.com>
Subject: Re: [patch 05/10] cifs: convert semaphore to mutex
From: Steve French <smfrench@gmail.com>
To: Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote on 01/29/2010 04:29:05 PM:

> Christoph Hellwig <hch@infradead.org>
> 01/29/2010 04:29 PM
>
> To
>
> Thomas Gleixner <tglx@linutronix.de>
>
> cc
>
> LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig
> <hch@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Ingo
> Molnar <mingo@elte.hu>, Jeff Layton <jlayton@redhat.com>, Steven
> French/Austin/IBM@IBMUS
>
> Subject
>
> Re: [patch 05/10] cifs: convert semaphore to mutex
>
> On Fri, Jan 29, 2010 at 08:38:50PM -0000, Thomas Gleixner wrote:
> > pSesInfo->sesSem is used as mutex. Rename it to session_mutex and
> > convert it to a real mutex.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Jeff Layton <jlayton@redhat.com>
> > Cc: Steve French <sfrench@us.ibm.com>
>
> Looks good, but I'm pretty sure I've seen an equivalent patch on the
> linux-cifs-client list before.
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Jeff and I acked the cifs part of the patch series in July - not sure
why the series didn't go in.

http://marc.info/?l=linux-kernel&m=124859649902788&w=2 looks like the
original post

-- 
Thanks,

Steve

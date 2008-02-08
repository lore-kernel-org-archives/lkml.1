Return-Path: <linux-kernel-owner+w=401wt.eu-S1761158AbYBHWMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158AbYBHWMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758816AbYBHWLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:11:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762649AbYBHWLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:11:42 -0500
Date: Fri, 8 Feb 2008 14:11:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/1] tty: BKL pushdown fix
Message-Id: <20080208141133.7a739f4f.akpm@linux-foundation.org>
In-Reply-To: <47ACCBD4.1000502@gmail.com>
References: <20080208154208.0efd6885@core>
	<1202497487-32550-1-git-send-email-jirislaby@gmail.com>
	<20080208133530.0e453c50.akpm@linux-foundation.org>
	<47ACCBD4.1000502@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 22:38:28 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 02/08/2008 10:35 PM, Andrew Morton wrote:
> > On Fri,  8 Feb 2008 20:04:47 +0100
> > Jiri Slaby <jirislaby@gmail.com> wrote:
> > 
> >> --- a/drivers/char/n_hdlc.c
> >> +++ b/drivers/char/n_hdlc.c
> >> @@ -579,7 +579,7 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
> >>  	}
> >>  
> >>  	lock_kernel();
> >> -	
> >> +
> > 
> > yeah.  I have a little script..
> 
> Note that it isn't only whitespace fixes in the patch.

Well no, I didn't note that.  The absence of any changelog led me to
believe that it was the obvious and trivial change which it appeared to be.

> I have one more -fix.

And that one had zero description either.

Please, it only takes 30 seconds.

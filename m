Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbXBYUDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbXBYUDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932322AbXBYUDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:03:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:14394 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbXBYUC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:02:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=Tr0gvxq6vJBvWJEXMEGGid4w9W2CHNgqqyVF3jtgocEGp7R7ZxrZRFi92WSIF4rmCjnEQ09OfqTVmJygLBocgkuOnkJ3oYXEMG+l5bZ8ZDPKa0hIbt9rB/XK6QIXkSCEyqlFjPpav7T+MYPtzwrbVVRpTkJRgf6fAhtR/S/Xpsk=
Date: Sun, 25 Feb 2007 20:01:39 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070225200139.GB31486@slug>
References: <20070221211355.GA7302@elte.hu> <20070224183421.GA6835@2ka.mipt.ru> <20070225172337.GB4998@elte.hu> <20070225174438.GA13647@2ka.mipt.ru> <20070225175437.GA9480@elte.hu> <20070225182135.GB29821@2ka.mipt.ru> <20070225182230.GA3622@elte.hu> <20070225183743.GD29821@2ka.mipt.ru> <20070225183438.GA6460@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225183438.GA6460@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 07:34:38PM +0100, Ingo Molnar wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > > thx - i guess i should just run them without any options and they 
> > > bind themselves to port 80? What 'ab' options are you using 
> > > typically to measure them?
> > 
> > Yes, but they require /tmp/index.html to have http header and actual 
> > data page. They do not parse http request :)
> 
> ok. When i connect to the epoll server via "telnet mysever 80", and 
> enter a 'request', i get back the content - but the socket connection is 
> not closed. Every time i type enter i get a new content back. Why is 
> that so - the code seems to contain a close(fd).
> 
I'd say a close(s); is missing just before return 0; in
evtest_callback_client() ?

Regards,
Frederik

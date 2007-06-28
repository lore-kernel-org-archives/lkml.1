Return-Path: <linux-kernel-owner+w=401wt.eu-S1763920AbXF1QYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763920AbXF1QYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXF1QYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:24:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:14679 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXF1QYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I24w73a7L/AFS5L7JOkG2E2QAKx5OIqogT7s5NrZ1bhhqDPesl4tW1razxGosAyx4z9iT+45WDZfy5fBtEbxuXdGRzW5kLRWQTQ6KYPwo6vE3IoTwnRYeMiG2phphaEaootTMCzTMNYM0p5os44oG6QNv+pX5chfm6u2p7Tb3CE=
Message-ID: <a781481a0706280924y154d6472w721f8ec868dcaa3f@mail.gmail.com>
Date: Thu, 28 Jun 2007 21:54:08 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [PATCH] RFC: have tcp_recvmsg() check kthread_should_stop() and treat it as if it were signalled
Cc: "Jeff Layton" <jlayton@redhat.com>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <a781481a0706280844l7eec6067gd576d88619463fe9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608123527.9b4cdafe.jlayton@redhat.com>
	 <E1HwpmG-0008LW-00@gondolin.me.apana.org.au>
	 <20070609070826.7bd3480c.jlayton@redhat.com>
	 <a781481a0706251241n36126456x7f4b445a86d1a68f@mail.gmail.com>
	 <20070626115449.GA92@tv-sign.ru>
	 <a781481a0706261553i1e65e620o884708d0b068b0f8@mail.gmail.com>
	 <20070627122437.GA158@tv-sign.ru>
	 <a781481a0706271744i9181641sff43e2053dde0f9@mail.gmail.com>
	 <20070628141246.GA95@tv-sign.ru>
	 <a781481a0706280844l7eec6067gd576d88619463fe9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> [...]
> [ BTW even there
> we're safe as long as we check kthread_stop() _before_ flushing or
                                 ^^^^^^^^^^^^^^

Whoops, that should have been "kthread_should_stop()".

> dequeueing the signals, but then that'll be an ugly rule to try and
> enforce, of course. ]

Satyam

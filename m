Return-Path: <linux-kernel-owner+w=401wt.eu-S1750850AbXBVAze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850AbXBVAze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbXBVAze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:55:34 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:56587 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbXBVAzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:55:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gb3+T0pm+vVDH3gKCRppZ16nu098+GDW1bgbmHq4fXRjFtUvb3fKZ3zmIVyQP3XGpmLtexGBm3VO3gKBnpf1dxWA67488550juWufvFw3rorOIuj5Q20VED1mUF+BQBiUJHLJhYk4frStHJoO2SKBfZA0CtL9ecwGmVozX9mBlU=
Message-ID: <f2b55d220702211655w6271051ap6d053d716deb02aa@mail.gmail.com>
Date: Wed, 21 Feb 2007 16:55:32 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070221232407.GA5895@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221232407.GA5895@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Ingo Molnar <mingo@elte.hu> wrote:
> pthread_cancel() [if/once threadlets are integrated into pthreads] ought
> to do that. A threadlet, if it gets moved to an async context, is a
> full-blown thread.

The fact that you are proposing pthread_cancel as a model for how to
abort an unfinished threadlet suggests -- to me, and I would think to
anyone who has ever written code that had no choice but to call
pthread_cancel -- that you have not thought about this part of the
problem.

Cheers,
- Michael

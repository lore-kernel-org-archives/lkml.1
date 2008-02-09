Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYBIS4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYBIS4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 13:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbYBIS4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 13:56:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:42733 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbYBIS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 13:56:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ItufZ6nPAbyT1VAnGmHpmY/aX7URN8nxPPSCeM6w/ZjwuJSM53Pfq06nkBsAsscImLDUI9VyGmLHjt7qH4kVFW3XDtc5F4Gu937NZly6MKlsG+vFk3TQSMjyFn4prXt/5YHICFy5Sd5OUNUMZIaUZ/itI5qbj3x4c9WqhsFW5Z8=
Message-ID: <84144f020802091056hffc22eckbda461534e3a6072@mail.gmail.com>
Date: Sat, 9 Feb 2008 20:56:07 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [RFC PATCH] x86: explicit call to mmiotrace in do_page_fault()
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080209202353.0e83e337@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201660453.8837.13.camel@brick>
	 <20080203085522.2b63e15b@daedalus.pq.iki.fi>
	 <20080203070321.GA8293@elte.hu>
	 <20080205222807.7b35ef2b@daedalus.pq.iki.fi>
	 <20080205223958.2cab8ce3@daedalus.pq.iki.fi>
	 <20080207125327.GB27234@elte.hu> <20080207125622.GA7111@infradead.org>
	 <20080209195255.584d4157@daedalus.pq.iki.fi>
	 <20080209100133.60406c00@laptopd505.fenrus.org>
	 <20080209202353.0e83e337@daedalus.pq.iki.fi>
X-Google-Sender-Auth: 7de33be52839cddc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Feb 9, 2008 8:23 PM, Pekka Paalanen <pq@iki.fi> wrote:
> By default it reserves 32 MB/cpu of relay buffers during module init.
> It's this big based on experimentation with the nvidia proprietary driver.
> There is no other way than unloading the module to free the buffers, or
> even to clear them. This means that every time you start the user space
> logger application, it gets old data first. Also poking the module
> parameters via /sys is not allowed.

So how is mmiotrace different from, say, blktrace that has an ioctl()
to setup/teardown the relay channels (for mmiotrace it can be a
"status" file that does the setup/teardown when written some
appropriate values)?

                             Pekka

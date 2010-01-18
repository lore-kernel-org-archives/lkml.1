Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360Ab0ARQFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0ARQFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303Ab0ARQFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:05:42 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54032 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab0ARQFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:05:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wDoymMxucIjUdEgaYq918krQAZ2jS3ahV5zB9XQbB/TPV+NF+lTlTP8ZuuCOkbZQ/t
         LIj1JshoU2xZMErFgBdfk4sbZXDtxCgA5d1yjhXuCkCZZ3flFH5qCjoIHgtnhDVrUDaQ
         ahUo1GhE6MiZkeLB0lTw/kwd1W6pcE6VPBiao=
MIME-Version: 1.0
In-Reply-To: <20100118141938.GI30698@redhat.com>
References: <20100118133755.GG30698@redhat.com>
	 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
	 <20100118141938.GI30698@redhat.com>
Date: Mon, 18 Jan 2010 18:05:38 +0200
X-Google-Sender-Auth: 2600eef9d0ebb65a
Message-ID: <84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 4:19 PM, Gleb Natapov <gleb@redhat.com> wrote:
> The specific use cases were discussed in the thread following previous
> version of the patch. I can describe my specific use case in a change log
> and I can copy what Andrew said about his case, but is it really needed in
> a commit message itself? It boils down to greater control over when and
> where application can get major fault. There are applications that need
> this kind of control. As of use of mlockall(MCL_FUTURE) how can I make
> sure that all memory allocated behind my application's back (by dynamic
> linker, libraries, stack) will be locked otherwise?

Again, why do you want to MCL_FUTURE but then go and use MAP_UNLOCKED?
"Greater control" is not an argument for adding a new API that needs
to be maintained forever, a real world use case is.

And yes, this stuff needs to be in the changelog. Whether you want to
spell it out or post an URL to some previous discussion is up to you.

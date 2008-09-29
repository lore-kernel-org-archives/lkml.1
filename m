Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYI2PE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYI2PE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYI2PET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:04:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:22241 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYI2PER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=loXk7INv+MaU0P9uwNxA5gd55zAtVeMYXJhAv72X1pewBkLbM+gNbdgU9Kdr7NPfA5
         WYBJWXyz5UjuG3feIbHaLMIvL1ksO3QZjzqZNZqxIXRQMWT6P/fL7nsdqv/AkKXQkq0x
         1vtdRkHS/bcss2LhC128y1i6bZBNoQFn6uBug=
Date: Mon, 29 Sep 2008 18:04:09 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [Path -tip 1/3] Tracing/ftrace: Change the type of the
 print_line callback
Message-ID: <20080929180409.68cdf8ba@daedalus.pq.iki.fi>
In-Reply-To: <c62985530809290211l7df01459lf80456ab98fc6ed0@mail.gmail.com>
References: <48DCFEE1.4010102@gmail.com>
	<20080928191918.1b26c0ab@daedalus.pq.iki.fi>
	<c62985530809290211l7df01459lf80456ab98fc6ed0@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 11:11:15 +0200
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 2008/9/28 Pekka Paalanen <pq@iki.fi>:
> 

[static int print_trace_line(struct trace_iterator *iter)]

> > Shouldn't the return type be bool?
> > If it's not, reading this function makes me wonder about the conversion
> > from enum to int, i.e. what is the meaning of the int.
> 
> Actually it should be enum print_line_t. I forgot to change its type.
> But we need to check its return value as an enum print_line_t.

Is print_line_t necessary? Does it have to return any other information than
"this entry was handled somehow" vs. "this entry must be handled later"?
Currently it's just a flag to say "please flush and retry".

-- 
Pekka Paalanen
http://www.iki.fi/pq/

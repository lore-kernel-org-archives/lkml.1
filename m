Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYLMP1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYLMP1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 10:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYLMP0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 10:26:51 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:14594 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYLMP0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 10:26:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ErI6bF/Ksx2IY2r+hbXaAAQ2F79oO2IiifmAuxrLujcBlDLeeMQTiIutj9H1sUDFaT
         L2pZ6JldXzQsqlbZCai6+OmmthXCdyzpf73VWW8qdpeFnLSxE0zm8wdQsC967TGpPRly
         sfj3dWRpGGjbqbkjf90/S5qWpXlVjr1AXH29s=
Message-ID: <c62985530812130726k1ee69c9dof67260f479fd8263@mail.gmail.com>
Date: Sat, 13 Dec 2008 16:26:49 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Steven Rostedt" <srostedt@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@fastmail.fm>
In-Reply-To: <20081213151600.GA12556@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081212184136.GB14192@localhost>
	 <20081212204724.GA26194@localhost>
	 <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com>
	 <20081212205729.GA28554@localhost>
	 <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com>
	 <20081212213538.GA731@localhost>
	 <alpine.DEB.1.10.0812121655090.19351@gandalf.stny.rr.com>
	 <20081213082054.GA7559@localhost>
	 <c62985530812130646r6bcdf424o752f16458dd22914@mail.gmail.com>
	 <20081213151600.GA12556@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/13 Cyrill Gorcunov <gorcunov@gmail.com>:
> Hi Frédéric,
>
> I didn't play with tracer internals since was more concerned about
> asm part of code. If you find that we better should introduce
> additional deps here or change a "deps graph" itself - I think it
> will be easy to place a new patch on top of this (or replace my
> patch) :)
>
> The only thing I would change in mine patch is -- subq/addq $0x38, %rsp
> since the following code uses decimal system but not a big deal anyway.
>
>                - Cyrill -


Yes, don't worry, these comments weren't relied on your patch :-)
If some work has to be done on deps, it will be on top of your patch
if Ingo applies it.

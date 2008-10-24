Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYJXNyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYJXNyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYJXNyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:54:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:23503 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbYJXNym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M8K+4T20ZtKlzonChMUGrONVPHDbqDK5T+s7yTMfnhxbgDGUci6GT2B0+gWckJGJ+F
         6tuHVKIla4DscA7pYerUq24aGHuISO4YKeufOllvnhTona2KvytWWaaT83jUJoQ765Mz
         vD3Q1PT8NrmfEjmcOu6W9CO6s/RtUoDFlB5LA=
Message-ID: <c62985530810240654o3e58a0abt12221507855be005@mail.gmail.com>
Date: Fri, 24 Oct 2008 15:54:40 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: handle archs that do not support irqs_disabled_flags
Cc: "Ingo Molnar" <mingo@elte.hu>, "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0810240937130.3882@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
	 <49008D12.5090204@gmail.com>
	 <Pine.LNX.4.64.0810231635440.18978@anakin>
	 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
	 <Pine.LNX.4.64.0810231727430.18978@anakin>
	 <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain>
	 <20081023163850.GB16591@elte.hu> <4901D8CD.7000405@gmail.com>
	 <alpine.DEB.1.10.0810240937130.3882@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/24 Steven Rostedt <rostedt@goodmis.org>:
> This patch adds a 'X' in the output to let the user know that the
> architecture they are running on does not support a way for the tracer
> to determine if interrupts were enabled or disabled. It also lets those
> same archs compile with tracing enabled.

That's almost exactly what I thought to repair the warning caused by those
FLAG_IRQS_NOSUPPORT archs :)

So we have now all the three patches that correct the warning reported
by Alexey in
Linux-next: http://lkml.org/lkml/2008/10/23/145

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764945AbYETT0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764945AbYETT0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765333AbYETTZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:25:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:10129 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764979AbYETTZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hpA1ocNrk7BPTtff13WC/9E6SM9Br8iHblZF95d6cma0QFnzggirlo0y9EjotddKXXJY09yE9GlwlhKzPNgA8EQuCrU3b+Qk6TJcJGIg7GBDoXpicoHdB85WFjMF7GiHIvymCnUR/drir2eDr0iPjVpj3akSCop6QepGDjhEGtA=
Message-ID: <3efb10970805201225s787cf9e2mfd115ad9b27ad6ab@mail.gmail.com>
Date: Tue, 20 May 2008 21:25:31 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Robert Schwebel" <r.schwebel@pengutronix.de>
Subject: Re: 2.6.25.4-rt2 compile errors on ARM due to cmpxchg() problems.
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, lvcargnini@gmail.com,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080520191159.GL13814@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970805200721u6a837a2ap94ead54f7eb7bf89@mail.gmail.com>
	 <Pine.LNX.4.58.0805201034130.1838@gandalf.stny.rr.com>
	 <20080520191159.GL13814@pengutronix.de>
X-Google-Sender-Auth: d267e890ff59d9bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

2008/5/20, Robert Schwebel <r.schwebel@pengutronix.de>:
> Hi Steven,
>  On Tue, May 20, 2008 at 10:34:54AM -0400, Steven Rostedt wrote:
>  > No idea right off the bat. But I may be needing to set up a ARM
>  > crosscompiler. Unless Thomas would like to take a look into this.
>
> If you need an ARM cross compiler, you can for example use ptxdist to
>  setup an OSELAS.Toolchain:

In that case, here are my 2 cents ;-)))

If you do not want to bother building a compiler toolchain and just
want to have a compiler very quickly, you can also download the
precompiled Codesourcery compiler toolchain for ARM for free...
http://www.codesourcery.com/gnu_toolchains/arm/download.html

They provide toolchains for PowerPC and MIPS too...
(Always handy for cross compile checks)


Kind Regards,

Remy

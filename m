Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbZKQMpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbZKQMpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:45:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZKQMpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:45:00 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:42913 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZKQMo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:44:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nNZhjGjm1Sr1tpRWyp6/aSG4vC++HyqR1vn++rrBCQaZE7XrXPQRSMWOSA7Ctr+9VO
         rV51XIgvWV/p9FSeXFhumPHeRRZbn/ioM3fg8CIyaQyKl5NpDIRdXUPzZRjBRlYw+Mm+
         FauGPF1NKcj3dyA2S0yGyydNzbT5cw3MXGjuw=
MIME-Version: 1.0
In-Reply-To: <1258447997.27437.76.camel@localhost>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
	 <4AFC4D31.2000101@gmail.com>
	 <20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>
	 <20091113091031.3f6d4bba@marrow.netinsight.se>
	 <1258112748.21596.1227.camel@localhost> <4AFE6A14.4010507@gmail.com>
	 <1258447997.27437.76.camel@localhost>
Date: Tue, 17 Nov 2009 13:45:02 +0100
Message-ID: <2ea1731b0911170445x13225c19w797388d2211de2d9@mail.gmail.com>
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
From: Marco Stornelli <marco.stornelli@gmail.com>
To: dedekind1@gmail.com
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David VomLehn <dvomlehn@cisco.com>, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org, dwm2@infradead.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/17 Artem Bityutskiy <dedekind1@gmail.com>:
> Take a look at my mails where I describe different complications we have
> in our system. We really want to have an OOPS/panic + our environment
> stuff to go together, at once. This makes things so much simpler.
>
> Really, what is the problem providing this trivial panic-note
> capability, where user-space can give the kernel a small buffer, and ask
> the kernel to print this buffer at the oops/panic time. Very simple and
> elegant, and just solves the problem.
>
> Why perversions with time-stamps, separate storages are needed?
>
> IOW, you suggest a complicated approach, and demand explaining why we do
> not go for it. Simply because it is unnecessarily complex.

I don't think it's a complicated approach we are talking of a system
log like syslog with a temporal information, nothing more.

> This patch solves the problem gracefully, and I'd rather demand you to point what
> is the technical problem with the patches.
>

Simply because I think that we should avoid to include in the kernel
things we can do in a simply way at user space level. I think this
patch is well done but it's one of the patches that are solutions "for
embedded only", but it's only my opinion.

Marco

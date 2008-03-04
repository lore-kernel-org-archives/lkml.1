Return-Path: <linux-kernel-owner+w=401wt.eu-S1763287AbYCDMvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763287AbYCDMvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYCDMvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:51:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:49713 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbYCDMvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:51:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YHkhW9wEBLxlkeeE1sgq/r4ySduValoq4n/mspTgQkotbYaj8UmtJA7ahfbuEecZmxj7rXZWgENiAlEJ+pQ4UuxQG1oYBqYKD1Fw0E03IeGKusVBKe04iC6UDVK34sod8Faqt83oNAoQh0goqNHsjPeweYWPp0d8CsJ00iLGBYA=
Message-ID: <84144f020803040451u562eb378h2d6c2378d1b174fe@mail.gmail.com>
Date: Tue, 4 Mar 2008 14:51:40 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [2.6.25-rc2-mm1] Oops in __kmalloc
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, "Jan Sonnek" <xsonnek@fi.muni.cz>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <47CD2753.5050905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47C42DDF.3060506@gmail.com>
	 <20080226100913.9412b41c.akpm@linux-foundation.org>
	 <47CD2753.5050905@gmail.com>
X-Google-Sender-Auth: f584a06f4b084b26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2008 at 12:41 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>  >> while booting up a notebook on 32 bit, this oopses appeared on the console
>  >> after ext3 fsck:
>  >> http://www.fi.muni.cz/~xslaby/sklad/mem_oops/
>  >>
>  >> It's 2.6.25-rc2-mm1, I can't find similar reports, is this known or hardware
>  >> issue (unlikely, 2.6.24.2 seems to be OK)?
>  >
>  > I don't recall seeing a similar report and yes, it'll be a kernel bug.
>  >
>  > We've fixed a few things and it could be that this will just go away in
>  > next -mm.  If it doesn't, a bisection search would be good, thanks.
>
>  Well, next -mm is out. Could you test, Jan? [our -mm git is up-to-date]

I don't see your config but if you have CONFIG_SLUB enabled, this is
probably the same problem as:

http://bugzilla.kernel.org/show_bug.cgi?id=10015

which is fixed since 2.6.25-rc2 in mainline.

                              Pekka

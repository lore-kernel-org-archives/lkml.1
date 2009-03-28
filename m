Return-Path: <linux-kernel-owner+w=401wt.eu-S1761130AbZC1VvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130AbZC1VvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZC1VvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:51:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:4592 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZC1VvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=kOtvaZyge/CTLHw3LDEaR4wMNriPvfgUrBw5SVCrhhhMx7nYaBOez+hz0uUnPU8NbI
         9eT7R5Tp7xfgRKyHTa38dscMb6bxZtno0oN3AuUXYX1jc9x5Ols1r1ePJ21s3uEH4pyE
         rKJpUCKq08jiYJPcTZ5sLJN6rx4j7gZKhCUOg=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Kasper Sandberg'" <lkml@metanurb.dk>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <01fc01c9afe9$5ecb43b0$1c61cb10$@com> <1238276579.6669.126.camel@localhost>
In-Reply-To: <1238276579.6669.126.camel@localhost>
Subject: RE: 2.6.29 network hosed?
Date: Sat, 28 Mar 2009 14:50:57 -0700
Message-ID: <020901c9afef$47064e90$d512ebb0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acmv7itI6nihFxk5RaehjFlB9qaGOwAANFWg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. I knew there was some problem with NAPI but I thought it had been
fixed.

I'll try the patch on Monday.

> -----Original Message-----
> From: Kasper Sandberg [mailto:lkml@metanurb.dk]
> Sent: Saturday, March 28, 2009 2:43 PM
> To: Hua Zhong
> Cc: 'Linux Kernel Mailing List'
> Subject: Re: 2.6.29 network hosed?
> 
> Hello.
> 
> Yes, this is a common issue with network, please search lkml for a post
> made by david miller, with subject: "Re: Network died completely in
> 2.6.29", Message-Id: <20090327.155346.98210435.davem@davemloft.net>
> 
> On Sat, 2009-03-28 at 14:08 -0700, Hua Zhong wrote:
> > I downloaded 2.6.29 and the network seems to be hosed on my desktop.
> Normal
> > ssh is fine, or light use of network. But whenever I run a perforce
> > integration the entire box just becomes completely dead on me. No
> traces,
> > warnings or printks. 100% reproducible. It's a FC4 based system (I
> know,
> > pretty old) for development.
> >
> > I only have an USB keyboard attached and it's not recognized after
> boot, so
> > no sysrq traces. Probably I have to upgrade udev? I can still use the
> > keyboard on the grub boot menu though.
> >
> > If it's a known issue please let me know. I'd be glad to test any
> patches.
> >
> > Hua
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbYEMRHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbYEMRHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYEMRH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:07:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:61590 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283AbYEMRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tlBQetwDMIzMFnUGH8KPQpz2iuYCq0z6ZIVH3tBh0JPQSlnJEZqAI824z1Xwq8AOSOgTRqLb7GSICvGw4YEeEp/3Xb5TdAcZDyIIb6W6xyESwBTrLWHAeoC6e9NFterW1eUMn7hlYclghnpCZzQSC/jTLoBITFF8Y5pzG4WVhlQ=
Date: Tue, 13 May 2008 21:07:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [patch 1/2] x86: head_64.S cleanup - use straight move to CR4
	register
Message-ID: <20080513170717.GE6921@cvg>
References: <20080513165538.952646389@gmail.com>> <4829c921.0305560a.489b.07db@mx.google.com> <4829C9EE.7020306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4829C9EE.7020306@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Tue, May 13, 2008 at 10:03:42AM -0700]
> Cyrill Gorcunov wrote:
>> There is no need for testing the values because we already know
>> what they should be. Just set them in straight way.
>
> He isn't testing them, he's setting individual bits.

not exactly - bts: bit test and set

>
> Either of these is pretty silly; the right way to do this is:
>
> 	movl	$(X86_CR4_PAE|X86_CR4_PGE), %eax
> 	movq	%rax, %cr4
>
> A movl in 64-bit mode zero extends.
>
> 	-hpa
>
ok, thanks Peter, i'll update in minute ;)

		- Cyrill -

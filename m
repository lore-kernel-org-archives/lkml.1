Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbYLFGae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbYLFGae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 01:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYLFGa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 01:30:26 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:2763 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYLFGaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 01:30:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ggKsep1kuzPjm96ll/ZY217r28JjZYAgDtoVPL2pg+X2YIP/fW6T/PHQT8JXXjUmfp
         cot/B2mFG+zZovIErg+T+UdRvqd82iZNZUhxN+twzwdMYEMPec1b5WtoOhF57ISAW2Yk
         UBFjQybFq0EvI5tqrcHulymw2US5L1WR7cSC4=
Message-ID: <21d7e9970812052230j705fc9bfi4a659378a43ca240@mail.gmail.com>
Date: Sat, 6 Dec 2008 16:30:24 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: IO space memcpy support for userspace.
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       libc-alpha@sources.redhat.com
In-Reply-To: <20081205202746.7DB20FC379@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970812041940h29994c60w3e7bcf20b96efe04@mail.gmail.com>
	 <20081205202746.7DB20FC379@magilla.sf.frob.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 6:27 AM, Roland McGrath <roland@redhat.com> wrote:
> There is never going to be something in memcpy that makes any magical
> kernel calls to find out about an address.  That's just loony, sorry.
> memcpy is inlined away by the compiler in good cases.  It's like you'd
> asked for "*ptr" to have magical constraints by the compiler generating
> code to ask the kernel if "ptr" is a special address.  Uh, really?
>

Yeah I didn't think it was a good idea, its what HPUX does, so that
implied it probably wasn't a good idea.

I was just hoping it might help people come up with a good idea.

Dave.

> If you can think of an efficient way to determine it and do what you need,
> then you could write optimized routines that do that in the vDSO perhaps.
>
>
> Thanks,
> Roland
>

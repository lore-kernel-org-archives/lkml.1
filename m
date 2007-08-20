Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbXHTXm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbXHTXm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbXHTXmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:42:46 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:56519 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbXHTXmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WFs3VgHttdWGE7lx2+qNhwowqrz6uX9064pg9us6R+gDWuIp3I4uPcaLJ7Q45S/RR+xN530ChaB70cuQWqaFzPh7eemapuyY5mvIXBs0ZTFGpdyN7yoKBkKgHBOHHXrDXnoE20fyf4AcymNQunLFsJJFBp+E21mFdh/NM3lm1jQ=
Message-ID: <646765f40708201642qf7d035bn2bcdadf3631fdf44@mail.gmail.com>
Date: Tue, 21 Aug 2007 09:42:39 +1000
From: "Julian Calaby" <julian.calaby@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 21/23] Add cmpxchg_local to sparc64
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, wli@holomorphy.com
In-Reply-To: <Pine.LNX.4.64.0708201636260.32662@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070820201519.512791382@polymtl.ca>
	 <20070820201831.178200926@polymtl.ca>
	 <646765f40708201634u5437f307l8259456c92af5cf5@mail.gmail.com>
	 <Pine.LNX.4.64.0708201636260.32662@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Tue, 21 Aug 2007, Julian Calaby wrote:
>
> > >    })
> > >
> > > +#include <asm-generic/cmpxchg-local.h>
> >
> > Shouldn't #includes go at the start of the file?
>
> Most of the timee but there are exceptions.

As with most things =)

However, in the context of this patch, is having the #include here
correct or not?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com

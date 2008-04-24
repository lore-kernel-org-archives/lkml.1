Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYDXQsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYDXQsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYDXQsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:48:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39338 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYDXQsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:48:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rXrfnZh/vmbLVEn5RYEyHSwI9Y/vQLE9Ivgt4RcyHybxOtic0UfciS2jJeFoFNnTwVN3kN9ciSJukjGUq8mHtbkDFewfMobnF/ASA3ofgsHOlfQ2RvQfN4M7z3GamAfd/vyS32xye8NUu2vZ2qMxqU4ppOjmHxygtbCbJhVtTQA=
Message-ID: <517f3f820804240948u788745f4s7a5dd4e7417ffeaf@mail.gmail.com>
Date: Thu, 24 Apr 2008 18:48:37 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Cc: "David Miller" <davem@davemloft.net>, torvalds@linux-foundation.org,
       drepper@redhat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       "akpm@linux-foundation.org Jakub Jelinek" <jakub@redhat.com>
In-Reply-To: <20080424164226.415cedeb@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	 <20080424112514.055d8071@the-village.bc.nu>
	 <alpine.LFD.1.10.0804240828100.2779@woody.linux-foundation.org>
	 <20080424.083908.147395158.davem@davemloft.net>
	 <517f3f820804240903y788102bar5c7d1fa9bcee1c8a@mail.gmail.com>
	 <20080424164226.415cedeb@the-village.bc.nu>
X-Google-Sender-Auth: e8b48307a837c93c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > But this approach fixes just one of the interfaces.  There are 7 or 8
>  > other interfaces that need to solve the same problem.  What about
>  > those?
>
>
> Actually it seems to fix most of them.

Am I missingg something?  How?  There a number of system calls that
have neither a flags argument, nor another argument that we can
overload (as you propose with socket()).  For those, we'd need new
system calls os sys_indirect().

> I accept Jakub's observation we
>  need a "paccept()" or similar.

True, that would be nice.

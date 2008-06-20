Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbYFTPEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbYFTPEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbYFTPEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:04:46 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:40895 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321AbYFTPEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aJp3SExM0oaYmomoBdqOMwQVgl4NMdefy1p8e1xWymMwAG6X6x5gYnGE20lL+Br0mT
         B3fWLQq8fzmrU+HW/OIfOLg4OaYsI7/KkBvCVVGjHLqdoqQP+Hx4IGEAZSqVhiXpOzIP
         QfhKanVRtzEWz7UkKQkpAc/mlHPUN7ijlChfg=
Message-ID: <86802c440806200804s29e6068bi6bbc60d6fc172277@mail.gmail.com>
Date: Fri, 20 Jun 2008 08:04:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: check command line when CONFIG_X86_MPPARSE is not set
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080620150151.GA17373@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200806191213.10312.yhlu.kernel@gmail.com>
	 <200806191215.01538.yhlu.kernel@gmail.com>
	 <200806200742.36226.yhlu.kernel@gmail.com>
	 <20080620150151.GA17373@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 8:01 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> we can not use acpi=off, acpi=noirq and pci=noacpi when mps support is
>> not there
>
> hm, i think instead of a panic() we should print a warning and fall back
> to nosmp - an UP bootup should work just fine without any mptable
> information.

will look at it.

YH

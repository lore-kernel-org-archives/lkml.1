Return-Path: <linux-kernel-owner+w=401wt.eu-S935388AbXGLV2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935388AbXGLV2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 17:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbXGLV2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 17:28:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12610 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbXGLV2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 17:28:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=gnddhTkn0o6u2x+ElHuPhrYZIEAkDEH7157d8CqRwuCNCckjNOghOPfWJx6Djx0kq
	I+QXw22ul1o/QgOKgWXeA==
Message-ID: <cc96a5040707121428j6c03fb6eyd27685a9f172ac23@mail.gmail.com>
Date: Thu, 12 Jul 2007 14:28:25 -0700
From: "Tim Hockin" <thockin@google.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [x86_64 MCE] [RFC] mce.c race condition (or: when evil hacks are the only options)
Cc: "Joshua Wise" <jwise@google.com>, akpm@google.com,
       linux-kernel@vger.kernel.org, "Mike Waychison" <mikew@google.com>
In-Reply-To: <200707122320.19489.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707121309520.617@internets.corp.google.com>
	 <200707122320.19489.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/07, Andi Kleen <ak@suse.de> wrote:

> > -- there may be other edge cases other than
> > this one. I'm actually surprised that this wasn't a ring buffer to start
> > with -- it certainly seems like it wanted to be one.
>
> The problem with a ring buffer is that it would lose old entries; but
> for machine checks you really want the first entries because
> the later ones might be just junk.

Couldn't the ring just have logic to detect an overrun and stop
logging until that is alleviated?  Similar to what is done now.  Maybe
I am underestimating it..

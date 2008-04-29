Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbYD2V6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbYD2V6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYD2V5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:57:51 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:20338 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYD2V5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:57:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d3qaqbEyTpfhSujkGDvUCR28bkJZtwpcrF6+rlVuY5xNon6E7Y/YEzMDQPMK7TYs4E8+XT4EIR21jq91c8QX4ny1TbiyesTK3mC298QHcxMtcD3nDgBVJNCYeIipgAaQYOKwv6aMLN0IywQNofFlgYfe1QCXyfQ8k0rRaIUS+k0=
Message-ID: <86802c440804291457k79099d84w53110fabf59e9e37@mail.gmail.com>
Date: Tue, 29 Apr 2008 14:57:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout v5
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mika Fischer" <mika.fischer@zoopnet.de>
In-Reply-To: <m1abjcz9ow.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804281244.56938.yhlu.kernel@gmail.com>
	 <200804281316.14168.yhlu.kernel@gmail.com>
	 <200804281505.05764.yhlu.kernel@gmail.com>
	 <m1wsmg32qk.fsf@frodo.ebiederm.org>
	 <86802c440804291304r7ff169f6k9132f98761ecef42@mail.gmail.com>
	 <m1abjcz9ow.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 1:29 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>  > (less memory + fast X) or  (more 8M RAM + slow...)
>
>  Yes. That is the basic question.  Not all X drivers need it and
>  potentially the current kernel drm modules can use the
>  PAT infrastructure that has been merged.
>
>  Further a SMM monitor running 100 times or more slower may cause
>  problems if SMM mode is entered frequently, slowing down the entire
>  system not just X.
>
>  So if you don't have X or you have a crazy SMM monitor this can
>  be an issue.

agreed. so that feature is compiled in but disable by default.

BTW: is any chance for OS to disable SMI etc? to verify is the
unstatbility is caused by SMI?

YH

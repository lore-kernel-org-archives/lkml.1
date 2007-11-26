Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbXKZBJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbXKZBJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 20:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXKZBJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 20:09:10 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:32409 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbXKZBJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 20:09:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=p0SGtYXfxywUQQM6YzwZYbbw4NIKvGKs4tg8BpIIPMuhzYTMD6j95x+tNvcvFAxy7JCSZgC18IlrmfuRpxxropoT+xwisrKmWE14I0Pbjx5iXTl0/fbvdaSwEBQZ6hzoyQrbLQZP62sFe/f+1Rv2/OOCXLvM6zyuY0YwQkpq320=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 23/27] x86: debugctlmsr kconfig
Date: Sun, 25 Nov 2007 17:09:01 -0800
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
References: <20071125215507.4B89226F8C5@magilla.localdomain> <20071125220802.76C2F26F8C5@magilla.localdomain>
In-Reply-To: <20071125220802.76C2F26F8C5@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711251709.01304.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 November 2007 14:08, Roland McGrath wrote:
> This adds the (internal) Kconfig macro CONFIG_X86_DEBUGCTLMSR,
> to be defined when configuring to support only hardware that
> definitely supports MSR_IA32_DEBUGCTLMSR with the BTF flag.
>
> The Intel documentation says "P6 family" and later processors all have it.
> I think the Kconfig dependencies are right to have it set for those and
> unset for others (i.e., when 586 and earlier are supported).
>
> +config X86_DEBUGCTLMSR
> +	bool
> +	depends on !(M586MMX || M586TSC || M586 || M486 || M386)
> +	default y

Why is it defined in configuration system instead of some *.h file?
--
vda

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYCaCNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYCaCNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYCaCNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:13:44 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:3262 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYCaCNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qhj5/Vkw8fJxfOV7JTZgX6ig0AJ6TCQ5PyNlQirYsIT/fbADl/5yo1BbRE5rXi9PreVAKdBye7Rd0nZv9LMXoNNdM+dUC56MZ4Iz4u2gI6vZkcQ7suxy60d7056+6oriJ6LuGoMachLw+vq9uAWQ4k5imSUIDqaYcgI4MfNHM44=
Message-ID: <86802c440803301913n1cd4fe88v2374a8ba835153e@mail.gmail.com>
Date: Sun, 30 Mar 2008 19:13:42 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Steiner" <steiner@sgi.com>
Subject: Re: [PATCH 8/8] x86_64: Support for new UV apic
Cc: "Andi Kleen" <ak@suse.de>, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080331020613.GA20619@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080328191216.GA16455@sgi.com>
	 <86802c440803301622j2874ca56t51b52a54920a233b@mail.gmail.com>
	 <20080331020613.GA20619@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 7:06 PM, Jack Steiner <steiner@sgi.com> wrote:
> > so this is "the new one of Friday"?
>
>  Yes, and it has the same bug although it is located
>  in a slightly different place.
>
>  A few minutes ago, I posted a patch to delete the extra lines.
>
>
>
>  > Did you test it on non UV_X2APIC box?
>
>  The code is clearly wrong.  I booted on an 8p AMD box and
>  had no problems. Apparently the kernel (at least basic booting) is
>  not too sensitive to incorrect apicids being returned. Most
>  critical-to-boot code must use apicids from the ACPI tables.
>  However, the bug does affect numa node assignment. And probably
>  other places, too.

please consider one global get_apic_id() and bad_apicid to replace
GET_APIC_ID and BAD_APICID at this point.

YH

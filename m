Return-Path: <linux-kernel-owner+w=401wt.eu-S934324AbXGQPJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324AbXGQPJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbXGQPIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:08:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22998 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934185AbXGQPIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:08:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SC8ArVVd6gaBTlsPP80l3tY/YoWb/2NomoIFxVvInPXyFjeoNJhcFYwIjgajDhfcG
	UF+iRyqnm+ix6Jjc3CpyQ==
Message-ID: <8f95bb250707170808u5afee515y592c0a0ccafa95b2@mail.gmail.com>
Date: Tue, 17 Jul 2007 08:08:24 -0700
From: "Aaron Durbin" <adurbin@google.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] ACPI: Add reboot mechanism
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com, akpm@osdl.org
In-Reply-To: <200707171331.59414.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716180019.GA5112@google.com> <200707171331.59414.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Andi Kleen <ak@suse.de> wrote:
> On Monday 16 July 2007 20:00:19 Aaron Durbin wrote:
> >
> > Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.
>
> Why? I had such a patch at some point as experiment, but it never
> helped actually fix a box.

I have a box here that it fixes, but I also don't see what it hurts. How much
are you against the patch? If the keyboard controller won't work and there are
issues using the triple fault, but if the RESET_REG is setup properly it will
definitely reboot the machine as intended with no ill side effects.

-Aaron

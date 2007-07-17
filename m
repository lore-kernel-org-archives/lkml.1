Return-Path: <linux-kernel-owner+w=401wt.eu-S934226AbXGQPsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226AbXGQPsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764127AbXGQPsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:48:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:26398 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934979AbXGQPsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:48:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qNGT0JlxbidtJ9ejwLcB/oHq6T3P4629JAtFkS7trZyisS6NgK4a5SehsDUkMzNkd
	SohWy0ZLGNe96Ua12vnvw==
Message-ID: <8f95bb250707170847t5b3aded3hb6d08f825362f76c@mail.gmail.com>
Date: Tue, 17 Jul 2007 08:47:56 -0700
From: "Aaron Durbin" <adurbin@google.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] ACPI: Add reboot mechanism
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, akpm@osdl.org
In-Reply-To: <200707171742.39067.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716180019.GA5112@google.com>
	 <86802c440707170740i30ed2110l130dafbec8e4d4a5@mail.gmail.com>
	 <8f95bb250707170808n19799ba5l3acd13e2ee7e0f08@mail.gmail.com>
	 <200707171742.39067.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Andi Kleen <ak@suse.de> wrote:
> On Tuesday 17 July 2007 17:08:19 Aaron Durbin wrote:
>
> > This is true if SMIs are still flowing, and the SMI handler correctly handles
> > the reset properly. I have seen cases where the SMI handler is broken which
> > causes the system to perpetually hang.
>
> Ah, that is the rationale that was missing in the first mail ...
> Ok that makes some sense. Is it a common issue?
>

I am not sure in how common it is, but I have access to some machines around
here that are displaying this issue.

-Aaron

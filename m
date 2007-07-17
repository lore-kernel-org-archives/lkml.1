Return-Path: <linux-kernel-owner+w=401wt.eu-S934428AbXGQPO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934428AbXGQPO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759114AbXGQPOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:14:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbXGQPOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:14:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SrwNz4pL2o6ovgXRdnAavLLXhMJOHykiCXvhuCmLfYAwLOJDSZxqSmaY4Vv5Rw4su
	ZTUL9+d8CSkzbT+rQVtKw==
Message-ID: <8f95bb250707170814w61b91a4dtf8a2c28505445516@mail.gmail.com>
Date: Tue, 17 Jul 2007 08:14:42 -0700
From: "Aaron Durbin" <adurbin@google.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: Make ACPI the default reset option
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <200707171332.31519.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716180221.GA5370@google.com> <200707171332.31519.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Andi Kleen <ak@suse.de> wrote:
> On Monday 16 July 2007 20:02:21 Aaron Durbin wrote:
> >
> > Make ACPI be the default reset method for x86_64. If the reset mechanism fails
> > using ACPI, it will default to using the keyboard controller.
>
> Again why?
>
> You really can't just throw out these patches without any explanation.
>

Sorry. It was more of just getting a proposal on thoughts on making this
default. I wasn't too sure it would fly. :) I should have been more explicit
with my intentions. It does fix some broken systems I have seen though with
no ill side effects. I would like to see this tested on more than the systems
I have access to in order to see what kind of fall out there is.

-Aaron

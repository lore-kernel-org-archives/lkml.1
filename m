Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbYFEQEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbYFEQEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYFEQEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:04:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:19673 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbYFEQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:04:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=kaCNWyiAoXi+LkvW4RqtLCEsTWQGMBv73LMRmZZxo7BNENIHSpYZ672n8T9Khrl0Z
	+BHOvmhG7/aI91waWtzqg==
Message-ID: <4ca0a85e0806050903o5960bfb9o482e4124b631f6cb@mail.gmail.com>
Date: Thu, 5 Jun 2008 12:03:53 -0400
From: "Thomas Tuttle" <ttuttle@google.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH 2/5] pagemap: Change kpagecount to return the map count, not the reference count, of a page.
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1212681667.3953.159.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ca0a85e0806050804s798bba46wcb29d2582120bfab@mail.gmail.com>
	 <1212681667.3953.159.camel@calx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 12:01 PM, Matt Mackall <mpm@selenic.com> wrote:
>
> On Thu, 2008-06-05 at 11:04 -0400, Thomas Tuttle wrote:
>> When trying to use pagemap to calculate the "proportional set size"
>> [1] of a process, I discovered that there were often references to
>> pages that could not be discovered by kpagecount.  I changed
>> kpagecount to return the number of times a page is mapped, rather than
>> referenced, so kpagecount is more useful for determining how many
>> processes are using a page.
>
> I'm pretty sure this has been suggested before and I was just too
> thick-skulled to get it. Yes, the reference count is less useful.
>
> Acked-by: Matt Mackall <mpm@selenic.com>
>
> ps: It's much prefered to send patches inline.

Oh.  Sorry about that.  (It's been a while since I sent patches to LKML.)

--ttuttle

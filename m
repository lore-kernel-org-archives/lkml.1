Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbXFUTRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbXFUTRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbXFUTRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:17:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33342 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbXFUTRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:17:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qBMFJubYZTB1l86RAo3BiSQWnyT++x5WmjFa0MHJVlG4Pq5xWQwwQap1fHjphBNxj
	U/qWLT9RZuUC0tgg+Ihhw==
Message-ID: <6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>
Date: Thu, 21 Jun 2007 12:17:27 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
Cc: "Andrew Morton" <akpm@osdl.org>, "Pavel Emelianov" <xemul@openvz.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070620154655.13844.42876.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>
> Display the current usage and limit in a more user friendly manner. Number
> of pages can be confusing if the page size is different. Some systems
> can choose a page size of 64KB.

I'm not sure that's such a great idea. "Human-friendly"
representations would make programmatic parsing harder.

What's wrong with just showing counts in bytes in the control files?

Paul

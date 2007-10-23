Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbXJWGJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbXJWGJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXJWGJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:09:35 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37930 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbXJWGJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:09:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=o4ZK3kadfmYbi0WW2jiM+nNqQTbCVnkZmzXd7keY7goJR+0WnFqGjurGZahiryvSf
	6MAkQvMU5pL64soImEuqw==
Message-ID: <6599ad830710222309j599d0e38xa7c4bdf7c160019a@mail.gmail.com>
Date: Mon, 22 Oct 2007 23:09:29 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <471D67B5.1020802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471D4523.4040509@google.com> <471D67B5.1020802@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> I think we also need the notion of load, like we have in cpu_acct.c

Yes, a notion of load would be good - but the "load" calculated by
cpu_acct.c isn't all that useful yet - it's just a total of the CPU
cycles used in the 10 second time interval prior to the current
interval. Something that's more analagous to the real machine load
would be nice, and I hope the numbers could be made available via CFS.

> Don't we need to do a css_get() on the cgrp to ensure that the cgroup
> does not go away if it's empty and someone does an rmdir on it?

See my other email. Yes, I think we need more here, but probably
something more generic.

Paul

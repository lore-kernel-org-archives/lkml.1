Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZFECD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZFECD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZFECDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:03:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54199 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbZFECDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:03:18 -0400
Message-ID: <4A287D5A.3000408@redhat.com>
Date: Fri, 05 Jun 2009 10:05:14 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [Patch 1/2] kbuild: two trivial fixes for check headers
References: <20090604080406.7005.27662.sendpatchset@localhost.localdomain> <20090604091519.GA9571@uranus.ravnborg.org> <4A27927E.9090800@redhat.com> <20090604103909.GA10102@uranus.ravnborg.org>
In-Reply-To: <20090604103909.GA10102@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> Rightfully is does...
> But is think it is a prototype of a function.
>
> But think about it - it does not makes sense to have an
> extern declarationof a variable in an exported header.
> There is no way that userspace can access this variable
> from user-space and therefore the declaration of the variable
> needs to be moved to a kernel-only header file.
>
>   

Agree, then the script looks wrong. I will fix it.

> So if you touch this I would ask you not to consider a single line
> in jffs-user.h - but rather take a critiacal look at the whole
> file and fix any issues there is.
> And then to send it to the mtd people (dwmw2).
> I did not look at the file but just looking at yout patch
> the "undef jemode_to_cpu" looks fishy in an exported header.
>   

Hmm, after googling a bit, I got this patch:

http://patchwork.ozlabs.org/patch/26224/

So I won't touch this.

Thanks.



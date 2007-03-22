Return-Path: <linux-kernel-owner+w=401wt.eu-S1030259AbXCVIJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbXCVIJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030238AbXCVIJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:09:32 -0400
Received: from gw.goop.org ([64.81.55.164]:48169 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030230AbXCVIJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:09:31 -0400
Message-ID: <460239BC.4070500@goop.org>
Date: Thu, 22 Mar 2007 01:09:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Avi Kivity <avi@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Cleanup: rationalize paravirt wrappers
References: <1174531311.2713.86.camel@localhost.localdomain>	 <46023096.8060809@qumranet.com> <1174550442.2713.128.camel@localhost.localdomain>
In-Reply-To: <1174550442.2713.128.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> The behaviour change (don't oops when an invalid rdmsr is used) was
> there with CONFIG_PARAVIRT=y, the cleanup just made !CONFIG_PARAVIRT the
> same.  Is it important?
>   

We could always fling a BUG_ON in the non-safe versions, which would
probably be more informative than a GPF or whatever a bad MSR gives you.

    J

Return-Path: <linux-kernel-owner+w=401wt.eu-S933880AbXHVVyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbXHVVyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932719AbXHVVyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:54:14 -0400
Received: from gw.goop.org ([64.81.55.164]:48193 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489AbXHVVyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:54:13 -0400
Message-ID: <46CCB088.8070606@goop.org>
Date: Wed, 22 Aug 2007 14:54:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com>
In-Reply-To: <46CBC842.4070100@vmware.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> This patch provides hypercalls for the i386 port I/O instructions,
> which vastly helps guests which use native-style drivers.  For certain
> VMI workloads, this provides a performance boost of up to 30%.  We
> expect KVM and lguest to be able to achieve similar gains on I/O
> intensive workloads.

Two comments:

- I should dust off my "break up paravirt_ops" patch, and this would fit
nicely into it (I think we already discussed this)

- What happens if you *don't* want to pv some of the io instructions? 
What if you have a device which is directly exposed to the guest?

    J

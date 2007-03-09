Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbXCIRYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbXCIRYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXCIRYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:24:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbXCIRYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:24:42 -0500
Message-ID: <45F19858.3070604@redhat.com>
Date: Fri, 09 Mar 2007 12:24:40 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: "No handler for vector" patches don't work on some systems
References: <45F188ED.7030202@redhat.com> <m1slce4b8r.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1slce4b8r.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Chuck Ebbert <cebbert@redhat.com> writes:
>>
>> So far I've tried the simple "survive having no handler
>> for a vector" patch and the preliminary 3-patch series
>> that was in -mm for a while, and neither work on the
>> Dell PowerEdge 29xx and 19xx systems. These servers
>> have the Intel 5000X chipset with the 6700PXH PCI Hub
>> with dual independent PCI-X busses, each with its own
>> I/OxAPIC with 24 interrupts. The fixes do work on
>> "simple" systems but not on these high-end ones.
> 
> 
> I would very much like to know if what I merged linus's tree helps.
> It is a little more conservative, than my earlier patches.  I need
> a way to reproduce this or to work closely with someone who is, because
> this sounds like it has a different cause and I need to start with
> that assumption.

Was that merged or is it still in -mm? The last thing I see in
arch/x86_64/irq.c is:

  	[PATCH] x86-64: survive having no irq mapping for a vector

And we tried that one.

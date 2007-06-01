Return-Path: <linux-kernel-owner+w=401wt.eu-S1763917AbXFAVra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763917AbXFAVra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbXFAVrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:47:24 -0400
Received: from gw.goop.org ([64.81.55.164]:53704 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760836AbXFAVrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:47:23 -0400
Message-ID: <466093E3.4010701@goop.org>
Date: Fri, 01 Jun 2007 14:47:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <466087CF.70708@goop.org> <4660924A.2070009@zytor.com>
In-Reply-To: <4660924A.2070009@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>> Do we care particularly? If 8 bytes is enough for the subarch, do we
>> care whether its a pointer or literal? After all, this is just a private
>> channel between the bootloader and some subarch-specific piece of code
>> in the kernel.
>>
>>     
>
> I see two options: either we make it a pointer *and a length* so that a
> loader can reshuffle it at will (that also implies no absolute pointers
> within the data), or it's an opaque cookie anyway.
>   

No, it has to be completely opaque.  It might be a pointer to some
special shared memory or something, and not movable.

    J

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbZE3CUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbZE3CUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 22:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZE3CT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 22:19:57 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36873 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbZE3CT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 22:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KPxuxiKtKjB+IZ1hT3di2xTvFu8sfL89yd1prQehotx6PbFqDGDqXruzYu81G0qnrh
         EYa3hOdd4xGkijblnMIGUQlHc9wI9zRz+aR8N18pT4eDVTfH+qUgIKbWzl7owM/o/r6p
         Y3tnFFx1Q9wwivebTYqSNl3MdhTlt2zd2y9f0=
MIME-Version: 1.0
In-Reply-To: <4A1F302E.8030501@goop.org>
References: <4A1C3453.6080402@redhat.com>
	 <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
	 <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org>
Date: Sat, 30 May 2009 03:19:56 +0100
X-Google-Sender-Auth: 548e29caa8d240a6
Message-ID: <b4057d410905291919t635290f6ia1e1a792a7ac4dfa@mail.gmail.com>
Subject: Re: [Xen-devel] Xen is a feature
From: Andy Burns <xen.lists@burns.me.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Wim Coekaerts <wimcoekaerts@wimmekes.net>,
       Ian Pratt <Ian.Pratt@citrix.com>,
       Stephen Spector <stephen.spector@citrix.com>,
       George Dunlap <George.Dunlap@eu.citrix.com>,
       "Kurt C. Hackel" <kurt.hackel@oracle.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xen-users@lists.xensource.com, Avi Kivity <avi@redhat.com>,
       Eric Anderson <EAnderson@novell.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Ky Srinivasan <ksrinivasan@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Keir Fraser <keir.fraser@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/29 Jeremy Fitzhardinge <jeremy@goop.org>:

> Ingo Molnar wrote:
>>
>> Xen changes - especially dom0 - are overwhelmingly not about improving
>> Linux, but about having some special hook and extra treatment in random
>> places - and that's really bad.
>>
>
> You've made this argument a few times now, and I take exception to it.
>
> There are at least 500k servers
> running Xen in commercial user sites (and untold numbers of smaller sites
> and personal users), running millions of virtual guest domains.
> To them, improved Xen support *is* "improving Linux".

Well said. I use xen both personally and in my business as a dozen or
so of those unseen millions of domUs, I've bitten my tongue for months
while watching xen developers jump through the hoops in order to get
pv_ops dom0 into the mainstream, only to be knocked back or left until
the next merge window and the next and the next.

Sure there were "the bad old days" of xen's history, but having been
asked the go the pv_ops route, I feel it is not just failing to
improve linux by keeping dom0 out of mainstream, but actually hurting
users and trapping them on ancient kernels which are missing newer
hardware support.

Sure, I wouldn't like to see any old rubbish merged into the kernel,
but I'm amazed at Jeremy's patience over this.

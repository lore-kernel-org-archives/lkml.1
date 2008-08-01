Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbYHAMpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbYHAMpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYHAMo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:44:56 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:46743 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbYHAMoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:44:55 -0400
X-Greylist: delayed 868 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2008 08:44:55 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pAoHyyzVsy/FZ/J1/zOIijXIpinPuKP4ZcoAtKsrjKxfW37yd9BpmGD6A7a5qcOsXd
         umr6O2mfIxNYIFmIuc9BDDljkJb9ZLJUorlbCcJiowkWwRXTta85nGmZLyyFneWdwxtH
         Em5FP805a3bMX18t+atvZILxGiKVCOo9gfEbw=
Message-ID: <2d460de70808010530j717dc5bdm73a44178605089e1@mail.gmail.com>
Date: Fri, 1 Aug 2008 14:30:24 +0200
From: "Richard Hartmann" <richih.mailinglist@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: iptables, NAT, DNS & Dan Kaminsky
Cc: "Willy Tarreau" <w@1wt.eu>, linux-kernel@vger.kernel.org
In-Reply-To: <2c0942db0807311436p6c61d2f0o9bfe67ffeaaf0e91@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2d460de70807300753w33c43340xaa52c54add501306@mail.gmail.com>
	 <20080730195548.GA615@1wt.eu>
	 <2d460de70807310759s2a7d6c4k5ba7e0e6a5bd9cf6@mail.gmail.com>
	 <20080731211406.GA19104@1wt.eu>
	 <2c0942db0807311436p6c61d2f0o9bfe67ffeaaf0e91@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are drifting from the initial topic, but oh well.. :)

On Thu, Jul 31, 2008 at 23:36, Ray Lee <ray-lk@madrabbit.org> wrote:


> or placing the DNS resolver behind a NAT
> masquerading firewall that does strict response dropping if a response
> comes from the wrong host. (There used to be an option in the kernel
> to deal with that -- loose source routing or somesuch, but I think
> that's a by-gone from the 2.4 era.)

You do not need a NAT to do this, you simply need to block packets
with a source address that does not match the routes your router has
in his routing table. Other than ISP end-costumers and a few other
very clearly defined situations, this is highly non-trivial, though. Some
people still do this, but in most cases, it has proved impractical and
a source of many 'strange' errors.


> So, to answer Richard, yes something like that should work. I'm not an
> iptables guru by any means, but what you should do is set up a machine
> with that, and sniff the output of the DNS server before and after
> enabling that line to verify that it works.

I know that this is possible.
What I wanted to know is what kernel versions do what [automagically]
and in what way.


> The better solution, of course, is to update your DNS server to allow
> it to do the source port randomization itself.

Of course. But I want to fully understand all cases and this is the last
area I still lack information on.


Thanks,
Richard

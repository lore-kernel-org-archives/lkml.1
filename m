Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbYJWBF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbYJWBF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYJWBFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:05:50 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:62872
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbYJWBFt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:05:49 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 21:05:48 EDT
X-Trace: 151204416/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAENo/0jDlSwG/2dsb2JhbACBdr4qg04
X-IronPort-AV: E=Sophos;i="4.33,467,1220223600"; 
   d="scan'208";a="151204416"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: high %CPU values after upgrading to the last stable kernel
Date: Thu, 23 Oct 2008 01:55:48 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.27-damocles; KDE/4.1.2; x86_64; ; )
Cc: "=?iso-8859-1?q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>,
       sbs <gexlie@gmail.com>, linux-kernel@vger.kernel.org
References: <53cc795f0810221237u1b5ece4dq477be67903dd5879@mail.gmail.com> <c62985530810221404k2987da81q3e158e203c379b89@mail.gmail.com> <2c0942db0810221540l4da55d92n2b55124908d08d3@mail.gmail.com>
In-Reply-To: <2c0942db0810221540l4da55d92n2b55124908d08d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810230155.48344.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008 23:40:54 Ray Lee wrote:
> On Wed, Oct 22, 2008 at 2:04 PM, Frédéric Weisbecker <fweisbec@gmail.com> 
wrote:
> > 2008/10/22 sbs <gexlie@gmail.com>:
[snip]
> >> should i upgrade procps or downgrade kernel then to get proper values
> >> back? :) or is it a feature of the new kernel?
> >>
> >> thank you
> >
> > Hi,
> >
> > It really depends on what your box is doing at the time you capture
> > the cpu usage.
> > And it really depends too of your kernel config...
>
> It really shouldn't, we're talking about /proc which is supposed to be
> a stable userspace interface.
>
> Try upgrading your procps, there's a chance it's just so ancient that
> it accidentally got broken. However, if that fixes your problem, then
> please report back with a subject line of "/proc API breakage" or
> somesuch, to get the proper attention to the issue.

This is a known kernel bug that for some reason wasn't fixed before 2.6.27 was 
released. See http://bugzilla.kernel.org/show_bug.cgi?id=11209 for details.

It would probably be useful if the OP added himself to the CC list, so Peter 
can get some more details about the box.

-- 
Cheers,
Alistair.

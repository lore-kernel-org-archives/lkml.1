Return-Path: <linux-kernel-owner+w=401wt.eu-S935279AbYBUXUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935279AbYBUXUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbYBUXUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:20:43 -0500
Received: from smtp5.freeserve.com ([193.252.22.152]:53304 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbYBUXUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:20:42 -0500
X-ME-UUID: 20080221232036270.41F7E1C00081@mwinf3421.me.freeserve.com
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: chris2553@googlemail.com
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Dan Williams <dcbw@redhat.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
In-Reply-To: <200802212304.28731.chris2553@googlemail.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <1203628049.3277.6.camel@boulder.homenet>
	 <200802212251.26897.IvDoorn@gmail.com>
	 <200802212304.28731.chris2553@googlemail.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 23:20:27 +0000
Message-Id: <1203636027.3186.5.camel@boulder.homenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 23:04 +0000, Chris Clayton wrote:
> On Thursday 21 February 2008, Ivo van Doorn wrote:
> > On Thursday 21 February 2008, Chris Vine wrote:
[snip]
> > > This probably explains the problem another user reported with rt61.
> > 
> > Perhaps something similar like:
> > http://bugzilla.kernel.org/show_bug.cgi?id=10058
> > in there a reference is made to the following patch:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/broken-out/revert-send-a-single-notification-on-device-state-changes.patch
> > 
> > Does applying that help?
> 
> I'm afraid not, Ivo. The test I ran last night was against 2.6.25.-rc2-git4 and
> that already has this patch applied. Furthermore, I have another card that uses
> the rtl8180 driver and that works reliably. I, therefore, suspect that my problem
> lies within the rt61pci driver or the rt2x00 infrastructure.

Does the same happen with 2.0.14 under kernel 2.6.24?

Chris




Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYBNRwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYBNRwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYBNRwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:52:15 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:13152 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730AbYBNRwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:52:14 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Mark McLoughlin <markmc@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization@lists.linux-foundation.org
In-Reply-To: <1203010675.16280.15.camel@muff>
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>
	 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
	 <1202988844.26435.4.camel@muff>
	 <1203008490.30818.69.camel@localhost.localdomain>
	 <1203010675.16280.15.camel@muff>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 17:51:56 +0000
Message-Id: <1203011516.30565.5.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=tnZBaFxVaJwA:10 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=vm_RNwRCUSswlFq5Zt4A:9 a=QSLGsBkEy-PPNXBCx5mFdUVdrE8A:4 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-14 at 17:37 +0000, Mark McLoughlin wrote:
> On Thu, 2008-02-14 at 17:01 +0000, Ian Campbell wrote:
> With this, AFLAGS would apply to building when building the
> prerequisites of header.o too, which you don't want
> 
> The make manual says:
> 
>   "when you define a target-specific variable that variable value is
>    also in effect for all prerequisites of this target, and all their
>    prerequisites"

Ah yes, quite right.

I think given that subtleties of these kinds of variable definitions
it's probably clearer to stick with the header file way of doing things.
it's nice and straight forward.

Ian.
-- 
Ian Campbell

Davis' Law of Traffic Density:
	The density of rush-hour traffic is directly proportional to
	1.5 times the amount of extra time you allow to arrive on time.


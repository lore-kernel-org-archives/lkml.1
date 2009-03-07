Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZCGUJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZCGUJR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 15:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZCGUJC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 15:09:02 -0500
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:52997 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbZCGUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 15:09:00 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-11.arcor-online.net DD53B21EF03
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Future of md multipath
To: martin f krafft <madduck@debian.org>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sat, 07 Mar 2009 21:08:54 +0100
References: <cbHe8-JR-9@gated-at.bofh.it> <ccbYG-sd-9@gated-at.bofh.it> <ccluS-7IV-3@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Lg2pL-0003s6-4e@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

martin f krafft <madduck@debian.org> wrote:
> also sprach Neil Brown <neilb@suse.de> [2009.03.05.0349 +0100]:

>> I'm in favour of deprecating it.  Whenever I hear of people using it I
>> suggest dm-multipath, but there could people I don't here about.
>> I think the upcoming mdadm-3.0 will need a compile-time option to
>> enable multipath, so people will only get it if they really really
>> want it.
> 
> How do you propose a distro to deal with this? Keep it enabled for
> a certain time (with a deprecation warning?) and then just to close
> the doors on users who still need it?

What about reverting the patch for their kernels until they release the
next major version, then drop it?

For users who compile their kernels, add "Deprecated" to the description,
and rename the CONFIG_.


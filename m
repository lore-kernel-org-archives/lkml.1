Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZINMiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZINMiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZINMiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:38:11 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:55020 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755305AbZINMiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:38:10 -0400
From: Frans Pop <elendil@planet.nl>
To: Salvatore Iovene <salvatore.iovene@googlemail.com>
Subject: Re: /lib/modules/2.6.31-10/build/drivers/input/hid-ids.h - where is it?
Date: Mon, 14 Sep 2009 14:38:09 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <c64207c00909140434t46d89025yaee72908143f128c@mail.gmail.com>
In-reply-To: <c64207c00909140434t46d89025yaee72908143f128c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909141438.11560.elendil@planet.nl>
X-OriginalArrivalTime: 14 Sep 2009 12:38:12.0846 (UTC) FILETIME=[3940A8E0:01CA3538]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salvatore Iovene wrote:
> I know that asking is not good netiquette, but could you please CC me
> if you reply? I'm not subscribed because this is really a one time
> question. Thanks!

It depends on the mailing list. For the kernel mailing lists it is 
actually standard to CC everybody.

> I have upgraded to Ubuntu 9.10 yesterday, and that brought in the
> 2.6.31-10 kernel. I always build the linuxwacom drivers myself, and
> they use the file in the subject (not 100% sure about the path,
> though: I recalled it from memory).
> Despite having all the dependencies that allowed me to build
> linuxwacom in the past, now that file is missing.

Note that when you build out-of-tree drivers you will never be guaranteed 
that your driver source will continue to build with a new kernel. When 
things break and you cannot solve the problem yourself, you should 
normally contact the organization or person where you got the driver, not 
the kernel community.

AFAICT in this case the file was simply moved to:
drivers/hid/hid-ids.h
        ^^^

Cheers,
FJP

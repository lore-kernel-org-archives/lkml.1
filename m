Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbZKXJfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbZKXJfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932455AbZKXJfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:35:03 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:64106 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbZKXJfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:35:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XF/mk/iRatfI669ksizB7RWX5Paw0vIljE6Nz6iQ8a9/DvZCwUlTXB3ipsH4/aN1FP
         yvBYRSYnwTmLOA9NtOp/HQ9xJISEtpRH7nRhocglj7yGHP9V3z52QjIH+1CmMbHhqrRm
         2YGWaaEdeb40lzhz69Yf3+pcLYwZeXSP873eo=
MIME-Version: 1.0
In-Reply-To: <4B0BA71B.8040800@ladisch.de>
References: <806dafc20911240054p74bd4d67h97430a02ba86b468@mail.gmail.com>
	 <4B0BA71B.8040800@ladisch.de>
Date: Tue, 24 Nov 2009 04:35:06 -0500
Message-ID: <806dafc20911240135u21b1157cif5c443144e8451c4@mail.gmail.com>
Subject: Re: PATCH: fix multiple eMagic 6|2m regressions introduced in 2.6.27
From: Monty Montgomery <xiphmont@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Der Mickster <retroeffective@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This has been discussed in this thread:
> http://lists.linuxaudio.org/pipermail/linux-audio-user/2009-November/064931.html

Ah, you got 80% of the way to where I did :-)

My 'bug 2' is the EXTERNAL->INTERNAL change that fixes the error -110
and allows the firmware to load.  However, as you've noticed, although
you get an endpoint the device then crashes because although it
succeeded in loading the firmware--- it was loading the  wrong
firmware.

The new bitstream.HEX file fixes that last problem.  It is merely a
reversion to the same firmware used in 2.6.26.  I assume that
overwriting the emi62s firmware with the firmware from the emi26 was a
mistake on someone's part.

As you've already got the loop fix and the EXTERNAL->INTERNAL fix, all
you need is the replacement bitstream.HEX:

http://web.mit.edu/xiphmont/Public/emi/bitstream.HEX

Monty

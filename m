Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZJKK1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZJKK1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 06:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbZJKK1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 06:27:22 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:56497 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756656AbZJKK1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 06:27:22 -0400
From: Frans Pop <elendil@planet.nl>
To: Olaf van der Spek <olafvdspek@gmail.com>, netdev@vger.kernel.org
Subject: Re: Enable syn cookies by default
Date: Sun, 11 Oct 2009 12:26:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <b2cc26e40910100601q7aed04acjcc9973ef06e6458f@mail.gmail.com>
In-reply-To: <b2cc26e40910100601q7aed04acjcc9973ef06e6458f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910111226.44828.elendil@planet.nl>
X-OriginalArrivalTime: 11 Oct 2009 10:26:45.0260 (UTC) FILETIME=[5509CCC0:01CA4A5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This question is better asked on the kernel network development list.
Original mail from Olaf below.

Cheers,
FJP

=================
Hi,

I'm forwarding Debian feature request #520668.

Could syn cookies be enabled by default?

AFAIK syn cookies only get send when the half-open TCP connection
queue is full. So stuff like window scaling should work fine in normal
situations.

Speaking of which:
When the half-open TCP connection queue is full and syn cookies are
enabled, you get a message like "kernel: possible SYN flooding on port
2710. Sending cookies."
However when syn cookies are disabled, you don't get any message (in
kern.log), although connections to your server are timing out.
Could such a message be added?
Maybe with a suggestion to increase the size of that queue or to
enable syn cookies.

Greetings,

Olaf

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=520668
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=520667
https://bugs.launchpad.net/ubuntu/+bug/57091

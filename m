Return-Path: <linux-kernel-owner+w=401wt.eu-S1750897AbXD1U0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbXD1U0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXD1U0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:26:45 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:46166 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXD1U0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DlfKWiUdRmaOFVhifGBZ7WtXjX5+66gkOBa7oUYiZ9poM+T9KqOncBbEsSQc5Agrj8rKggNHu78/hlGJNgBKajZ0i6KBYv6Y9JqEhjS3+3CZFeAd85knp4ZfLC6CT83eJBmaP7RtAG081lYivCAOBm/wp2y+2CU93Mek9ghxpuE=
Message-ID: <e294b46e0704281326w60f9cecfuace3442791f147b3@mail.gmail.com>
Date: Sat, 28 Apr 2007 21:26:42 +0100
From: "Bradley Chapman" <kakadu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CONFIG_HIGHMEM4G and 1GB RAM
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After installing a second 512MB SODIMM into my laptop, I noticed that
my 2.6.18.3 kernel only detected and used 896MB of the resulting 1GB,
and informed me that I needed to enable high memory in order to access
the remaining 127MB.

While doing so, I noticed that the help text stated that enabling high
memory (in my case, CONFIG_HIGHMEM4G) should only be done if the
system the kernel is running on has more than 1GB, but less than 4GB -
it said that systems with 1GB should leave it off, which resulted in
an eighth of the installed memory going missing. A bit more research
found a three year old thread on this list where it was stated that
enabling CONFIG_HIGHMEM4G sometimes slows the system down due to
sometimes undesirable changes to the way the kernel sets up the memory
map.

Basically, all I want to know is whether or not enabling
CONFIG_HIGHMEM4G for a laptop that has exactly 1GB of RAM will result
in any performance degradation.

TIA,

Brad

P.S: Direct replies please - I'm not subscribed to the list.

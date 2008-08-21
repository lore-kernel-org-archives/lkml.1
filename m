Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYHUV6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYHUV6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbYHUV6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:58:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36719 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264AbYHUV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:58:15 -0400
Message-ID: <48ADE317.5030809@zytor.com>
Date: Thu, 21 Aug 2008 14:50:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@linux.it>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: LinuxPPS (RESUBMIT 7): the PPS Linux implementation.
References: <> <1219238170-5508-1-git-send-email-giometti@linux.it>
In-Reply-To: <1219238170-5508-1-git-send-email-giometti@linux.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:
> This patch set adds the PPS support into Linux.

A couple of general questions about this (I don't know the background 
material in enough detail, so pardon if some of these are "obvious"):

1. Does this support (calibrated) sources with frequency other than
    1 Hz?
2. I assume that with the PPS line discipline loaded you can still read
    the data from the main pins on the serial port (almost always used
    for metadata?)

And a minor note: you use the term CD (Carrier Detect), but in most 
references the pin is labelled DCD (Data Carrier Detect).

	-hpa


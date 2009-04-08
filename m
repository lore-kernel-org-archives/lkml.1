Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbZDHFyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbZDHFyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757960AbZDHFyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:54:44 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2522 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbZDHFyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:54:43 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Michael Chan" <mchan@broadcom.com>
To: "'Robin Holt'" <holt@sgi.com>, "Matthew Carlson" <mcarlson@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Benjamin Li" <benli@broadcom.com>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Tue, 7 Apr 2009 22:54:33 -0700
Subject: Re: Linux 2.6.30-rc1
Thread-Topic: Linux 2.6.30-rc1
Thread-Index: Acm4DB0NR/3C4BloSpqLEImsrhC8DwACLITw
Message-ID: <C27F8246C663564A84BB7AB343977242176F6BF106@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20090408053721.GE10768@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 65C2E3935Y817732127-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:

> Booting an ia64 box with a tg3 adapter results in no network.
>  If I look
> at the MAC address of the adapter, it has changed radically from the
> original MAC.  The original MAC continues to be reported by EFI and
> booting an old kernel gets the correct MAC.
>
> Good MAC:     08:00:69:13:E6:3C
> Bad MAC:      00:00:3C:E6:13:69 (recreated from memory)

Looks like endian swapped.  Can you provide the entire tg3 signon
string?  Please also dump the beginning part of the nvram:

ethtool -e eth0 length 0x90

>
> If I set the MAC using ifconfig, then everything works normally.
>

The bad MAC address that has been swapped is also a valid MAC address
and should still work though.


Return-Path: <linux-kernel-owner+w=401wt.eu-S932970AbZJLRFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbZJLRFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932961AbZJLRFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:05:05 -0400
Received: from radagast.issp.eu ([86.59.99.45]:59190 "EHLO radagast.issp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932956AbZJLRFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:05:04 -0400
Message-ID: <20091012190427.149268crxg6ew0ow@www.kundendienste.net>
Date: Mon, 12 Oct 2009 19:04:27 +0200
From: Mathias Kub <lkml@makubi.at>
To: arndbergmann@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: DHCP and iptables
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much for that quick reply.

Yours Mathias Kub

--------------------
12.10.2009 Arnd Bergmann <arndbergmann@googlemail.com>

|   On Monday 12 October 2009, lkml@makubi.at wrote:
|   > The last few days I have been wondering about the fact, that I get an
|   > IP address via
|   > DHCP if all chains at iptables are set to drop and no accept rules set.
|   >
|   > Does this happen on purpose?
|
|   DHCP is an ethernet protocol, not an IP protocol, so you have to use
|   ebtables instead of iptables to filter it.
|
|   	Arnd <><

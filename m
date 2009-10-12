Return-Path: <linux-kernel-owner+w=401wt.eu-S932851AbZJLQnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbZJLQnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932788AbZJLQnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:43:22 -0400
Received: from radagast.issp.eu ([86.59.99.45]:52429 "EHLO radagast.issp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434AbZJLQnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:43:21 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 12:43:21 EDT
Message-ID: <20091012183441.64616r9da17njyww@www.issp.eu>
Date: Mon, 12 Oct 2009 18:34:41 +0200
From: lkml@makubi.at
To: linux-kernel@vger.kernel.org
Subject: DHCP and iptables
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

Hi,

The last few days I have been wondering about the fact, that I get an IP
address via
DHCP if all chains at iptables are set to drop and no accept rules set.

Does this happen on purpose?

I checked twice, if I really get an IP from my DHCP-server, checked the DHCP-
messages and a wireshark trace.

I Also tried the check_dhcp-nagios plugin, which fails if I do not allow
packets for the input chain, destination port 68, protocol udp.


Why do I get an IP address, if I drop everything?

Sincerely yours Mathias Kub

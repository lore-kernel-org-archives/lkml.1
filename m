Return-Path: <linux-kernel-owner+w=401wt.eu-S934865AbXFGSZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934865AbXFGSZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762745AbXFGSZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:25:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:48302 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761368AbXFGSZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jZ4AlGV5wp7NhR/Y8cIgDVK4sFZjm5Il//PVhfWC7lG6D6RDEZL+szD74kkwkvhHynYF+her+ClBlEK02c/7a0IniwFZC49o9MirEv7Y/RrNoxZn4bSw/pvARRvPz/6sIo/EDJdxHhXlLhUTYncLE/T7BWHbm/AQIBdnSnB7pwA=
Message-ID: <a44ae5cd0706071125p2079472eme52821bd134d26b0@mail.gmail.com>
Date: Thu, 7 Jun 2007 11:25:30 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc4-mm2 -- ipw2200 -- SIOCSIFADDR: No buffer space available
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This might be some problem with my kernel configuration.
I added:
CONFIG_BONDING=y

# dhclient eth1
There is already a pid file /var/run/dhclient.pid with pid 134993416
Internet Systems Consortium DHCP Client V3.0.4
Copyright 2004-2006 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/
SIOCSIFADDR: No buffer space available
Listening on LPF/eth1/00:12:f0:5e:db:2f
Sending on   LPF/eth1/00:12:f0:5e:db:2f
Sending on   Socket/fallback
DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 6
DHCPOFFER from 192.168.1.1
DHCPREQUEST on eth1 to 255.255.255.255 port 67
DHCPACK from 192.168.1.1
SIOCSIFADDR: No buffer space available
SIOCSIFNETMASK: Cannot assign requested address
SIOCSIFBRDADDR: Cannot assign requested address
SIOCADDRT: Network is unreachable
bound to 192.168.1.2 -- renewal in 2993 seconds.

# ping www.yahoo.com
ping: unknown host www.yahoo.com

Any suggestions what to try now?  I'll go ahead and turn off the
bonding option and see if that helps.

           Miles

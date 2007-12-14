Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbXLNLu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbXLNLu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXLNLuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:50:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:29796 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbXLNLuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:50:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=D6hvh8ujwd47LKVqjcYMTG8773A2lGPufw+EyEkCxFSG6Ph/QoYuu6O0eMxcAXW7AzgOpwk4Irzp+agvaGncGoS8reyZwEH/U9yuc3Gzi8Lpz+dzxCQw+KdKyuWPfWkkNZpg5FGfSSf7DKaGOsW0XDjFkw9s9dirG8+WBUId+ZQ=
Message-ID: <78c462ad0712140350v62ae169fm7a2ce077325ace5f@mail.gmail.com>
Date: Fri, 14 Dec 2007 17:20:17 +0530
From: "Amogh Hooshdar" <amoghhooshdar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 1.0.0.0 DNS replies for many domain names (network)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am having a strange problem with Debian Etch 4.0 (both 64-bit and
32-bit) using 2.6.18 kernel. Most websites do not open with browser,
Pidgin and most other GUI applicatoins. but I am able to ping them
fine. I am also able to do nslookup properly. When I tried to
investigate it with Wireshark net sniffer, I observed the following.

PROBLEM WITH 2.6.18
Say, I try to open www.google.com, browser sends DNS query for
www.google.com to my DNS server which is correctly configured in
resolv.conf. It replies with the correct IP address. www.google.com
redirects the browser to www.google.co.in. browser sends a DNS query
again for www.google.co.in and the DNS server replies with 1.0.0.0
which obviously is the wrong address.

Similar thing happens for many other domains like ftp.us.debian.org,
etc. It is quite random and happens 95% of the times. In other words I
am virtually not able to access internet.

OK WITH 2.6.20
The above was for Debian. With a Ubuntu 7.04 which has 2.6.20 kernel
everything is fine. no problems at all. With windows also no problem
at all.

Is this due to something in the 2.6.18 kernel which is related to the
way it sends a DNS query. Any information on this subject would be
highly appreciated since I am trying to understand why one distro
causes the problem and not the other. is it related to the kernel or
only to the distro?

Key words: DNS, domain, networking, IP address

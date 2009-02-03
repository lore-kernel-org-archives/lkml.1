Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZBCNxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZBCNxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZBCNxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:53:34 -0500
Received: from www17.your-server.de ([213.133.104.17]:58032 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZBCNxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:53:33 -0500
Message-ID: <20090203140731.37561541v6vi0t5f@mail.your-server.de>
Date: Tue, 03 Feb 2009 14:07:31 +0100
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Subject: ge kills my machine
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1)
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Shortly after starting google earth my machine is dead.
Google earth version is unknown. Strings command tells: "Jul  8 2008"  
and "18:49:53".
Before I was able to start google earth I needed to do:
"chcon -t textrel_shlib_t /opt/googleearth/lib*.so"
Because selinux prevented the execution of the libraries.

Kernel version I encountered the hang is:
2.6.27.12-170.2.5.fc10.i686
and
v2.6.29-rc3-430-gb1792e3

x11 driver is a self compiled radeonhd:
1.2.4-24-gb76bfbd

libdrm version is
$ yum info libdrm
Installierte Pakete
Name       : libdrm
Architektur : i386
Version    : 2.4.0
Ausgabe    : 0.21.fc10
Grösse     : 68 k
Repo       : installed

I tried to capture a possible oops via netconsole (eth0), but I got  
nothing back.

Ideas for solving this problem are welcome!

Greets
thomas


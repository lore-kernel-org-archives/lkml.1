Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbYIVNBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbYIVNBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYIVNBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:01:07 -0400
Received: from mail.bigtelecom.ru ([87.255.0.61]:47429 "EHLO
	mail.bigtelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYIVNBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:01:06 -0400
Message-ID: <48D79709.80400@bigtelecom.ru>
Date: Mon, 22 Sep 2008 17:00:57 +0400
From: Badalian Vyacheslav <slavon@bigtelecom.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080818)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: Denys Fedoryshchenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Machine Check Exception Re: NetDev! Please help!
References: <48D4F85C.8090709@bigtelecom.ru> <200809202111.01256.denys@visp.net.lb> <48D67239.9040006@gmail.com> <48D7385D.40107@bigtelecom.ru> <20080922065339.GA4399@ff.dom.local> <48D76813.9000603@bigtelecom.ru> <20080922112452.GB5314@ff.dom.local>
In-Reply-To: <20080922112452.GB5314@ff.dom.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> BTW: could you try to trigger this bug with one network card off?
>   


Shire! I stop eth1 and do "/etc/init.d/bgpd stop" (this pc not get route
traffic anymore)....

run "emerge portage" 2 times and get:

[25492.187405] CPU 3: Machine Check Exception: 0000000000000005
[25492.187405] MCE: The hardware reports a non fatal, correctable
incident occurred on CPU 1.
[25492.187405] Bank 0: b200004000000800
[25492.187405] MCE: The hardware reports a non fatal, correctable
incident occurred on CPU 1.
[25492.187405] Bank 5: b200120014040400
[25497.124884] CPU 1: Machine Check Exception: 0000000000000004
[25497.124884] Kernel panic - not syncing: Unable to continue
[25497.124884] Rebooting in 3 seconds..

bugtracker updated.... i can get (reproduce) error on all 10 servers at
2.6.26.5... I use TC and not wont test 2.6.27-rc because its have (if i
understand) multiqueue feature that not tested...

Thanks!

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765042AbXGTUUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765042AbXGTUUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbXGTUTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:19:48 -0400
Received: from khc.piap.pl ([195.187.100.11]:55192 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbXGTUTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:19:47 -0400
To: Ben Greear <greearb@candelatech.com>
Cc: andrei radulescu-banu <iubica2@yahoo.com>,
       Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Linux, tcpdump and vlan
References: <930446.33248.qm@web56601.mail.re3.yahoo.com>
	<469FF611.6080905@candelatech.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 20 Jul 2007 22:19:45 +0200
In-Reply-To: <469FF611.6080905@candelatech.com> (Ben Greear's message of "Thu, 19 Jul 2007 16:38:57 -0700")
Message-ID: <m3r6n2zv32.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear <greearb@candelatech.com> writes:

>> The net result is that dev_queue_xmit_nit() is called twice, once
>> for dev=eth0.2 then for dev=eth0.
>
> Maybe binding to all isn't such a good idea then.

Anyway I would expect the frame on eth0.2 and then on eth0 as well.
Anything different is crazy.
-- 
Krzysztof Halasa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763319AbYDPNIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763319AbYDPNIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbYDPNIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:08:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44972 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760420AbYDPNIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:08:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4805F9D1.5050602@s5r6.in-berlin.de>
Date: Wed, 16 Apr 2008 15:06:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: jszhang3@mail.ustc.edu.cn
CC: krh@redhat.com, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: fix sourceID read from wrong quadlet
References: <408349802.26451@ustc.edu.cn>
In-Reply-To: <408349802.26451@ustc.edu.cn>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jszhang3@mail.ustc.edu.cn wrote:
> From JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
> 
> In Asynchronous Receive Requests, the sourceID is in the second quadlet(OHCI 
> specification, section 8.7.1).

This has been fixed in Linux 2.6.25-rc1 by commit 
478b233eda81bfe41307512b8336fd688c6553e0 .  Thank you nevertheless,
-- 
Stefan Richter
-=====-==--- -=-- =----
http://arcgraph.de/sr/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbXKZKPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbXKZKPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbXKZKPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:15:25 -0500
Received: from mail.univits.se ([212.247.11.167]:38454 "EHLO mail.univits.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbXKZKPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:15:25 -0500
X-Greylist: delayed 1375 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2007 05:15:24 EST
Message-ID: <474A975A.8020302@univits.com>
Date: Mon, 26 Nov 2007 10:52:26 +0100
From: =?UTF-8?B?TWlrYWVsIFN0w6VsZGFs?= <mikael.staldal@univits.com>
Organization: Univits
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Possibility to adjust the only-root-can-bind-to-port-under-1024
   limit
References: <4742B3A3.2050103@univits.com> <20071120155303.76f234ec@astralstorm.puszkin.org>
In-Reply-To: <20071120155303.76f234ec@astralstorm.puszkin.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Radoslaw Szkodzinski (AstralStorm) skrev:
>> In Linux you have to be root in order to listen to TCP or UDP ports below 1024 (the 
>> well-known ports). As far as I know, this limit is hardcoded in the kernel.
>
> The proper way to enable port <= 1024 binding support is adding CAP_NET_BIND_SERVICE to 
 > the process capability set, e.g. by using file-system capabilities.

And how do you protect ports >1024 from any user binding to them?

Isn't the 1024 limit somewhat obsolete and arbitrary today?

/Mikael


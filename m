Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbXC1O0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbXC1O0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXC1O0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:26:49 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:46121
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbXC1O0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:26:49 -0400
Message-ID: <460A8941.4090405@microgate.com>
Date: Wed, 28 Mar 2007 09:26:57 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Stuart MacDonald <stuartm@connecttech.com>,
       "'Oliver Neukum'" <oliver@neukum.org>, linux-kernel@vger.kernel.org
Subject: Re: question on tty open and close
References: <200703281516.31366.oliver@neukum.org>	<019201c7713c$1a3277c0$294b82ce@stuartm> <20070328154439.40ca5c3c@the-village.bc.nu>
In-Reply-To: <20070328154439.40ca5c3c@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> I'm also not aware of any reason other than history, which means if
> someone cares to double check the other drivers there really shouldn't be
> an obstacle to "fixing" this behaviour.
> 
> Unless anyone knows different ?

As long as the new behavior continues to call
driver->close() if driver->open() succeeds
then I see no problem.

If individual drivers are correctly doing internal
reference counting to handle driver->close() calls
without a preceding successful driver->open() call
(usually just doing nothing), then they should
continue to operate correctly without the extra
and unnecessary driver->close().

-- 
Paul Fulghum
Microgate Systems, Ltd.

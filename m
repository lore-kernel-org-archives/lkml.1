Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYFPUF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYFPUF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYFPUFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:05:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41069 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbYFPUFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:05:48 -0400
Message-ID: <4856C795.2050007@garzik.org>
Date: Mon, 16 Jun 2008 16:05:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
References: <1213609751.26255.673.camel@pmac.infradead.org> <20080616115950.41bc65aa@lxorguk.ukuu.org.uk> <4856C6C8.6060506@garzik.org>
In-Reply-To: <4856C6C8.6060506@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Except for the part where the firmware is pointlessly separated from the 
> driver.

  ...in the kernel source tree, I mean.

No objection to extracting the firmware from the driver.

Driver maintenance will be more of a pain if we have most of a driver 
<here> in the tree, except for that one crucial piece hiding over <there>.

There is no reason why firmware must be artificially separated into 
firmware/

	Jeff




Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbYJYMq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbYJYMq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 08:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYJYMqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 08:46:17 -0400
Received: from rtr.ca ([76.10.145.34]:49496 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbYJYMqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 08:46:16 -0400
Message-ID: <49031537.4020807@rtr.ca>
Date: Sat, 25 Oct 2008 08:46:47 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
Cc: Tejun Heo <tj@kernel.org>, David Greaves <david@dgreaves.com>,
       linux-ide@vger.kernel.org,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [smartmontools-support] SMART to USB/sata dock in 2.6.27-rc5
 doesn't work
References: <48EE7E0A.8040701@dgreaves.com> <48F40164.5000502@kernel.org> <48F641A3.5080609@free.fr> <4900A0A7.3090102@rtr.ca> <4900C949.6040604@free.fr> <4900DCE4.3020901@rtr.ca> <4900E051.9040608@rtr.ca> <490219F7.7030908@free.fr>
In-Reply-To: <490219F7.7030908@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

matthieu castet wrote:
..
> I wonder with the patch doesn't make smartctl work without permisive. 
> May be your usb id wasn't in the patch.
..

Heh.. I didn't even look at the patch itself.
But if it is relying upon a whitelist to work,
then it's broken by design.

Most new USB drives will be supporting SAT,
and requiring a kernel patch/update (or some other
whitelist in userspace) is a silly way to support them.

Cheers

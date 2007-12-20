Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXLTCGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXLTCGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 21:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbXLTCGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 21:06:24 -0500
Received: from rtr.ca ([76.10.145.34]:1045 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXLTCGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 21:06:23 -0500
Message-ID: <4769CE20.5090307@rtr.ca>
Date: Wed, 19 Dec 2007 21:06:24 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux@horizon.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
References: <20071220013355.3900.qmail@science.horizon.com>
In-Reply-To: <20071220013355.3900.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux@horizon.com wrote:
>> Why does link(2) not support hard-linking across bind mount points
>> of the same underlying filesystem ?
> 
> Whenever we get mount -r --bind working properly (which I use to place
> copies of necessary shared libraries inside chroot jails while allowing
> page cache sharing), this feature would break security.
..

No, that would still function exactly as it does today.
The alternate behaviour that is desired for non-chroot purposes
would be per-bind-mount, and would require a mount flag to activate.

Cheers

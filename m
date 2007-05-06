Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbXEFOl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbXEFOl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 10:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXEFOl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 10:41:59 -0400
Received: from twin.jikos.cz ([213.151.79.26]:49161 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbXEFOl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 10:41:58 -0400
Date: Sun, 6 May 2007 16:41:51 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Folkert van Heusden <folkert@vanheusden.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.21] kernel panic
In-Reply-To: <20070506115651.GA13183@vanheusden.com>
Message-ID: <Pine.LNX.4.64.0705061632500.16923@twin.jikos.cz>
References: <20070506115651.GA13183@vanheusden.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007, Folkert van Heusden wrote:

> A few moments ago a system of mine running 2.6.21 on a P4 with
> hyperthreading, 2GB ram, IDE disk, crashed:
> [10371.128320] BUG: unable to handle kernel paging request at virtual address 00100100
> [10371.128419]  printing eip:
[...]
> [10371.131825] EIP is at hiddev_send_event+0xa1/0xd3

Hi,

I will look into it. Are you able to reproduce the problem, or did it 
happen just randomly? Is there any userspace driver using the hiddev 
interface at the moment it crashes?

There have been no changes in the hiddev code for a pretty long time.

Thanks,

-- 
Jiri Kosina

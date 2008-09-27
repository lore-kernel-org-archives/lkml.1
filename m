Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYI0MuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYI0MuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 08:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYI0MuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 08:50:11 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:37378 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYI0MuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 08:50:10 -0400
Message-ID: <48DE2BF7.3060905@davidnewall.com>
Date: Sat, 27 Sep 2008 22:19:59 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Swap on loop device on tmpfs locks up machine
References: <19f34abd0809261146j72a68765i964466336a3a34dc@mail.gmail.com>
In-Reply-To: <19f34abd0809261146j72a68765i964466336a3a34dc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> It turns out that swap over loop device on tmpfs will lock up the
> machine.

Doesn't tmpfs use otherwise-free virtual memory?  I expect the machine
would lock up if you put swap (i.e. additional virtual memory) on such a
device.

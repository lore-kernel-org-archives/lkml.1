Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbXICK4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbXICK4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXICK4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:56:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:35414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbXICK4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:56:14 -0400
To: <colin.michael@o2online.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [patch] enable userspace cpu core voltage control with acpi-cpufreq
References: <200709021441.l82EfWCe022642@mail.mc.o2online.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 03 Sep 2007 12:56:13 +0200
In-Reply-To: <200709021441.l82EfWCe022642@mail.mc.o2online.de>
Message-ID: <p738x7oaugi.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<colin.michael@o2online.de> writes:

> i want to make a patch known that provides a userspace interface to control the core voltage of a computer processor(s).

That would be essentially linux supported undervolting which 
for stability is as bad as overclocking. The problem is that 
such games tend to generate weird kernel crashes and then
chew up development issues when kernel hackers have to chase
ghost bugs. I don't think we should support it. Developer 
time is too precious.

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbXCYTqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbXCYTqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXCYTqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:46:45 -0400
Received: from www.osadl.org ([213.239.205.134]:38232 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752195AbXCYTqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:46:44 -0400
Subject: Re: Kernel 2.6.20 takes a long time to load
From: Thomas Gleixner <tglx@linutronix.de>
To: Helmut Auer <vdr@helmutauer.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46066970.20802@helmutauer.de>
References: <46066970.20802@helmutauer.de>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 21:45:46 +0200
Message-Id: <1174851946.3892.4.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 14:22 +0200, Helmut Auer wrote:
> Hello List,
> 
> The kernel 2.6.20 makes a long delay during booting ( about 15 seconds ) after showing:
> 
> NET: Registered protocol family 2
> 
> then it goes along with:
> 
> IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> TCP established hash table entries: 8192 (order: 4, 98304 bytes)
> ...
> 
> I am using the kernel parameter lpj to avoid calculating processor speed during kernel load.
> If I do not use the lpj parameter, the detection of cpu speed takes about 10 seconds, but then 
> there is no delay after:
> NET: Registered protocol family 2
> 
> Any hints what I can try to get a fast booting kernel ?
> I am using 2.6.20 with some gentoo patches ( plain 2.6.20-4 has the same problem ).
> 
> My .config is here:
> http://www.helmutauer.de/.config-2.6.20.3.gz

Can you put up a complete bootlog too ?

	tglx




Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZA0O6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZA0O6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 09:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZA0O6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 09:58:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:40303 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbZA0O6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 09:58:39 -0500
Message-Id: <0D5BDAF5-E5FD-42FC-977C-B83664FE4C78@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: sharing an interrupt between a cascaded/chained pic and another device
Date: Tue, 27 Jan 2009 08:57:54 -0600
Cc: linux-kernel Kernel <linux-kernel@vger.kernel.org>,
       Peters Ted <Ted.Peters@freescale.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Ingo,

Do we have any support in the kernel today to deal with a IRQ on the  
root PIC being used for both a chained PIC and shared with another HW  
device.  We have a board that guys went and did it and as I look at  
the kernel code it doesn't seem like this crazy situation is currently  
supported.

- k

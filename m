Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZFULpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZFULpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZFULpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:45:15 -0400
Received: from mailhost5.gawab.com ([66.220.20.5]:48655 "HELO info14.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752166AbZFULpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:45:14 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Peter Chacko <peterchacko35@gmail.com>, David Miller <davem@davemloft.net>
Subject: [RFD] Pluggable code design (was: can we reuse an skb)
Date: Sun, 21 Jun 2009 14:46:13 +0300
User-Agent: KMail/1.5
Cc: rick.jones2@hp.com, radhamohan_ch@yahoo.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <962874.62146.qm@web94813.mail.in2.yahoo.com> <20090619.162957.156347025.davem@davemloft.net> <1f808b4a0906202241l1d74364ft52d99ecb6b0274f5@mail.gmail.com>
In-Reply-To: <1f808b4a0906202241l1d74364ft52d99ecb6b0274f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906211446.13665.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Chacko wrote:
> What i am considering here is the super optimization of memory buffers
> for a multi-layer packet processor, without needing to move packets
> into user space. In that case, i am optimizing my custom network stack
> with a pre-allocated MTU sized and a few  jumbo-sized buffers. And no
> interrupts as i do NAPI at all times, as this is a dedicated
> appliance. I keep all these buffers in the L1 cache and hence i have
> different sets of pools for different cores. I  am currently guiding
> my engineers to implement the code changes now..

Yes, having a customizable/pluggable network stack sounds very useful.

In general, OpenSource projects like Linux don't give much incentive to 
pluggable designs, because the source, being open, represents a weired form 
of pluggability.  Unfortunately, this "hack it up / code it hard" design 
style usually inhibits healthy development.

A rethink is probably in place...


Thanks!

--
Al

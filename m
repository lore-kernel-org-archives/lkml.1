Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYL3M1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYL3M1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbYL3M0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:26:35 -0500
Received: from lucidpixels.com ([75.144.35.66]:55975 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbYL3M0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:26:31 -0500
Date: Tue, 30 Dec 2008 07:26:30 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: 2.6.27/2.6.28: irqbalance dies shortly after starting the daemon on
 x86 but not x86_64, why?
Message-ID: <alpine.DEB.1.10.0812300706390.11356@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(same on both x86 and x86_64):
# cat /etc/default/irqbalance
#Configuration for the irqbalance daemon

#Should irqbalance be enabled?
ENABLED=1
#Balance the IRQs only once?
ONESHOT="0"

========
my x86 system:
========

# /etc/init.d/irqbalance start
Starting SMP IRQ Balancer: irqbalance.

# ps auxww | grep -i irqbalance
root      4570  0.0  0.0   2536   436 ?        Ss   07:07   0:00 /usr/sbin/irqbalance

# sleep 300; ps auxww | grep -i irqbalance
#

=========
On my x86_64 systems:
=========

$ ps auxww | grep -i irqbalance
root      2769  0.0  0.0   8828   492 ?        Ss   Dec27   0:06 /usr/sbin/irqbalance
$ ps auxww | grep -i irqbalance
root      2918  0.0  0.0   8828   520 ?        Ss   Dec22   0:18 /usr/sbin/irqbalance

Is there a bug on x86?

Justin.


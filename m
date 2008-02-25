Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbYBYUff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbYBYUff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756789AbYBYUf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:35:28 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:45244 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533AbYBYUf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:35:27 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: net: tx timeouts with skge, 8139too, dmfe drivers/NICs
Date: Mon, 25 Feb 2008 22:37:12 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802252237.12326.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I experience very rare freezes at heavy outbound traffic 
(sending ~4GB DVD image to another host(s) on the same LAN) 
using skge driver (NIC on the mobo) as well as (recently tested)
using rtl8139 or dmfe NICs on the PCI bus. There is a single 
switch between them (tested with another one just to exclude
a faulty switch).

skge <--> Marvell 88E8001 chip
8139too <--> Realtek 8136B chip
dmfe <--> Davicom DM9102 chip

Symptoms are similar: tx timeouts and no more net activity.
KDE desktop works, computational programs - work, the machine 
is usable, but cannot ping, nor can be ping-ed anymore.
rmmod && modprobe the respective modules repairs the problem.
Simple surfing/e-mailing from it do not trigger the problem.

The machine is used as LTSP server for old PCs (as X terminals)
(mostly outbound traffic) and is not usable as such due to this
problem.

The kernel is 2.6.24.2-SMP/x86_32 (PREEMPT or not - NO difference).

As far as this happens with 3 different NICs/drivers could it be
a problem in the (common for all of them) networking subsystem?

As far as many persons are working on this machine only limited 
testing could be done.

Thank you in advance for your suggestions, help (and patches).

Regards.

Marin Mitov

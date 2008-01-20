Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYATTxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYATTxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 14:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbYATTxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 14:53:32 -0500
Received: from mx1.suse.de ([195.135.220.2]:51129 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbYATTxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 14:53:31 -0500
From: Andi Kleen <ak@suse.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.24 regression: reference count leak in PPPoE
Date: Sun, 20 Jan 2008 20:53:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801202053.30386.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My workstation running 2.6.24-rc8 just hung during shutdown with an endless 
(or rather I didn't wait more than a few minutes) loop of 

unregister_netdev: waiting for ppp-device to become free. Usage count = 1

ppp-device was an active PPPoE device.

No more information currently.

-Andi

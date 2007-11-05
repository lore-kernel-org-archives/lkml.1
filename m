Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXKESlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXKESlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbXKESlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:41:36 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:54999 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbXKESlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:41:35 -0500
Date: Mon, 5 Nov 2007 21:41:56 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [0/4] Distributed storage. Squizzed black-out of the dancing back-aching hippo.
Message-ID: <20071105184155.GA26175@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm pleased to announce 7'th and the final release of the distributed
storage subsystem (DST). It allows to form a storage on top of local and
remote nodes and combine them in linear or mirroring setup, which in
turn can be exported to remote nodes.

Short changelog:
* added strong checksum support (Castagnoli crc)
* extended autoconfiguration (added ability to request if remote
	side supports strong checksum and turn it on if needed)
* documentation addon - sysfs files
* added clean/dirty sysfs files which allows to mark
	node as clean (sinc) or dirty (not sync)
* fair number of bug fixes (including really tricky
	bastards, which are unlikely to be found in real
	setups, but which were still bugs)
* and the main one - added release name (it clearly shows my condition)

Overall list of features of the DST can be found on project's homepage:

http://tservice.net.ru/~s0mbre/old/?section=projects&item=dst

Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>


-- 
	Evgeniy Polyakov

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXGXIuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXGXIuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbXGXIuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:50:40 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:12848 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbXGXIuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:50:39 -0400
Date: Tue, 24 Jul 2007 12:51:06 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
Subject: dm: device mapper code cleanup.
Message-ID: <20070724085106.GD20538@dnb.sw.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SWsoft
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've prepared patch-set which i hope makes dm code safer and better :)
- First tree patches fix various leaks.
- Last five patches just convert kmalloc + memset couple to single kzalloc
   (probably it should be folded to one commit).


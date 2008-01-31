Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYAaPe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYAaPe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYAaPer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:34:47 -0500
Received: from smtprelay06.ispgateway.de ([80.67.18.44]:34513 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbYAaPeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:34:46 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 10:34:46 EST
Date: Thu, 31 Jan 2008 16:28:23 +0100
From: Lars Noschinski <lklml@ml.noschinski.de>
To: linux-kernel@vger.kernel.org
Subject: How does ext2 implement sparse files?
Message-ID: <20080131152823.GA29422@lars.home.noschinski.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-Df-Sender: 336680
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello!

For an university project, we had to write a toy filesystem (ext2-like),
for which I would like to implement sparse file support. For this, I
digged through the ext2 source code; but I could not find the point,
where ext2 detects holes.

As far as I can see from fs/buffer.c, an hole is a buffer_head which is
not mapped, but uptodate. But I cannot find a relevant source line,
where ext2 makes usage of this information.

Any hints would be greatly appreciated,
     Lars.

[Please CC me on answers, I'm not subscribed]

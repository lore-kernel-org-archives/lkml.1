Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbYBSNB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbYBSNB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYBSNBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:01:51 -0500
Received: from qmta04.westchester.pa.mail.comcast.net ([76.96.62.40]:35556
	"EHLO QMTA04.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739AbYBSNBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:01:51 -0500
X-Authority-Analysis: v=1.0 c=1 a=rITDv7nW5hcA:10 a=hgEGcxHA-a83RtzTSTAA:9
 a=JTzvmw8OIkvV1Y4_psXV4gofA34A:4 a=6-x43y6uxGMA:10
To: linux-kernel@vger.kernel.org
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
Subject: Where to put adapters
Date: Tue, 19 Feb 2008 08:01:48 -0500
Message-ID: <20080119080148.eklhad@comcast.net>
Mime-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that notifiers are in, (yay!), people are going to start writing adapters
for visually and motor impaired individuals.
I suggest we place them in drivers/adapters in the source tree,
and I suggest they put their virtual files in the directory /proc/adapters,
which would be created via fs/proc/root.c as part of the /proc file system.
Adapter foo would create /proc/adapters/foo, and put its files in that directory.
Naturaly it would rm -r /proc/adapters/foo upon module exit.

I'm already working on my third adapter, and we need some kind of organization.
What do you think?

If you like, I can write and submit a patch that does this.

Karl Dahlke

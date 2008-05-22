Return-Path: <linux-kernel-owner+w=401wt.eu-S1766008AbYEVOC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766008AbYEVOC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 10:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYEVOCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 10:02:49 -0400
Received: from testure.choralone.org ([194.9.77.134]:55423 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbYEVOCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 10:02:48 -0400
Date: Thu, 22 May 2008 10:04:02 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Andrew Morgan <morgan@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com
Subject: capget() overflows buffers.
Message-ID: <20080522140402.GB2071@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Andrew Morgan <morgan@kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had a user file a bug report recently that sys_capget is overflowing
a user buffer.

More details and test program are available at
https://bugzilla.redhat.com/show_bug.cgi?id=447518

The only recent change in this area was e338d263a76af78fe8f38a72131188b58fceb591
"Add 64-bit capability support to the kernel".

	Dave


-- 
http://www.codemonkey.org.uk

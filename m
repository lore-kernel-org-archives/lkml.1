Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYFPPG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYFPPG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYFPPGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:06:04 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:1882 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbYFPPGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:06:03 -0400
Date: Mon, 16 Jun 2008 17:05:50 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Linux with kvm-intel locks up VMplayer guest is started
Message-ID: <20080616150550.GA16086@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I start a guest in vmplayer, my laptop locks up hard.  I found
out that this only happens when the kvm-intel module has been loaded.
When I unload this module, I can start vmware guests just fine.

I see this problem on a HP Compaq 2510p notebook with Intel Core2 Duo
U7600 @ 1.20GHz, but http://laptop006.livejournal.com/41314.html
describes exactly the same problem on a Lenovo T61 (custom build),
Core 2 T7500 on a Santa Rosa.  I've seen this with at least 2.6.24 and
2.6.25.

I don't have a serial console, but I started VMplayer and
immediately switched to the console but nothing is displayed
(i.e. no kernel panic; it simply locks up hard).

Any idea if this is a kernel bug, BIOS issue or a bug in VMplayer?

-- 
Martin Michlmayr
http://www.cyrius.com/

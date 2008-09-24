Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbYIXIG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbYIXIG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYIXIGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:06:13 -0400
Received: from eazy.amigager.de ([213.239.192.238]:52740 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYIXIGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:06:12 -0400
Date: Wed, 24 Sep 2008 10:05:48 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Regression in 2.6.27-rc7: Wake On LAN with sky2 broken
Message-ID: <20080924080546.GA21108@x61>
Mail-Followup-To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Wake On LAN from suspend to RAM doesn't work on my Mac mini Core Duo
with 2.6.27-rc7. I tested the same configuration with 2.6.26.3, and it
worked. With 2.6.27-rc7, the computer stays in suspended state. I can
still wake it up using the keyboard or power switch.

In my suspend script, I use the command "ethtool -s eth0 wol g" to
enable WOL even if it was disabled before.

Any hints what commit I should try to revert, before I start bisecting?

Regards,
Tino

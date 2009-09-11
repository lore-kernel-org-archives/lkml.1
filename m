Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZIKO5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZIKO5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZIKO5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:57:06 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:43068 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006AbZIKO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:57:05 -0400
Subject: special HID & Kconfig: odd behavior in gconfig
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux-input@vger.kernel.org
Content-Type: text/plain
Date: Fri, 11 Sep 2009 15:57:07 +0100
Message-Id: <1252681027.2282.23.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use gconfig & and cannot turn off any of the special HID devices.

the Kconfig for them all have the same pattern e.g.

config HID_DRAGONRISE
	tristate "DragonRise Inc. support" if EMBEDDED
	depends on USB_HID
	default !EMBEDDED

The 'if EMBEDDED' on the tristate line seems to confuse gconfig and it
sets them all to m & does not let me set them to N. I'm building this on
a standard desktop machine.

Any idea what the intention of this was? or can we just remove the if
embedded part?

thanks

Richard



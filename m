Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0CGOb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 09:31:26 -0500
Received: from solo.fdn.fr ([80.67.169.19]:48177 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab0CGObZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 09:31:25 -0500
Date: Sun, 7 Mar 2010 15:31:12 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, lenz@cs.wisc.edu, rpurdie@openedhand.com
Subject: private field in led_classdev?
Message-ID: <20100307143112.GC5203@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, lenz@cs.wisc.edu,
	rpurdie@openedhand.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Would there be an objection to adding a void *private field to the
led_classdev struct?  It would be a lot less burden for the input
key board leds support for finding out the keyboard device from the
brightness_set callback, as each device may have a long series of leds,
not just a fixed number of them.

Samuel

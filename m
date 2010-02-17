Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253Ab0BQNqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:46:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53745 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933923Ab0BQNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:46:45 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [RFC 0/3] A little console mystery...
To: linux-kernel@vger.kernel.org
Date: Wed, 17 Feb 2010 13:22:47 +0000
Message-ID: <20100217131931.17289.68158.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone feeling inspired. These three patches move the console to use the
tty_port interface and refcounting. The first two work perfectly, the third
which we really need works beautifully except that it breaks mingetty/login
stuff.

[So not for the main kernel if you like using text consoles]

I have been staring at this problem for ages and I'm clearly missing something
silly because I've still not pinned down why mingetty etc break with the
third patch applied.

---

Alan Cox (3):
      vt: Fix refcounting use
      tty: Move the vt_tty field from the vc_data into the standard tty_port
      tty: Make vt's have a tty_port



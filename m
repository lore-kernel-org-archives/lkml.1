Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab0CAN3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:29:32 -0500
Received: from gherkin.frus.com ([192.158.254.49]:58697 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab0CAN3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:29:31 -0500
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2010 08:29:30 EST
Date: Mon, 1 Mar 2010 07:11:01 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Subject: K6-III/450 MTRR support
Message-ID: <20100301131101.GA8644@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone got a quick way to determine whether MTRR support is working
correctly on this old CPU?  "cat /proc/mtrr" doesn't show anything
configured in cases where I used to see a few entries.  Using the "nv"
driver (Xorg 1.6.3 dated 2009-07-31: latest version for Slackware 13)
produces two error messages...  This one appears in syslog:

kernel: mtrr: no MTRR for d0000000,4000000 found

and this one appears as the last line of output to the virtual console
after shutting down the X server:

waiting for X server to shut down error setting MTRR (base = 0xd0000000, \
size = 0x04000000, type = 1) Invalid argument (22)

Here are the applicable kernel config lines: if the config doesn't make
sense, I'm sure someone will let me know.  The last time I *know* MTRRs
worked properly was before the PAT and SANITIZER options showed up:
yeah, that far back...

CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y

--Bob

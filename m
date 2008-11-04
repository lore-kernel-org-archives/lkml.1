Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYKDXjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYKDXjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbYKDXhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:37:45 -0500
Received: from mx1.suse.de ([195.135.220.2]:47180 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865AbYKDXho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:37:44 -0500
Date: Tue, 4 Nov 2008 15:31:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Scott James Remnant <scott@ubuntu.com>,
       Tim Gardner <tcanonical@tpi.com>, Corey Minyard <minyard@acm.org>
Subject: [patch 05/57] ipmi: add MODULE_ALIAS to load ipmi_devintf with
	ipmi_si
Message-ID: <20081104233106.GF659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipmi-add-module_alias-to-load-ipmi_devintf-with-ipmi_si.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Scott James Remnant <scott@canonical.com>

commit 6c89161b10f5771ee0b51ada0fce0e8835e72ade upstream

The ipmi_devintf module contains the userspace interface for IPMI devices,
yet will not be loaded automatically with a system interface handler
driver.

Add a MODULE_ALIAS for the "platform:ipmi_si" MODALIAS exported by the
ipmi_si driver, so that userspace knows of the recommendation.

Signed-off-by: Scott James Remnant <scott@ubuntu.com>
Cc: Tim Gardner <tcanonical@tpi.com>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/ipmi/ipmi_devintf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -957,3 +957,4 @@ module_exit(cleanup_ipmi);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Corey Minyard <minyard@mvista.com>");
 MODULE_DESCRIPTION("Linux device interface for the IPMI message handler.");
+MODULE_ALIAS("platform:ipmi_si");

-- 

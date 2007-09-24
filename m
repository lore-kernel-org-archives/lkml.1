Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbXIXQZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbXIXQZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbXIXQYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:24:39 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47150 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785AbXIXQYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:24:38 -0400
Date: Mon, 24 Sep 2007 09:19:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [02/50] DVB: get_dvb_firmware: update script for new location of
	sp8870 firmware
Message-ID: <20070924161948.GC13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dvb-get_dvb_firmware-update-script-for-new-location-of-sp8870-firmware.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Michael Krufky <mkrufky@linuxtv.org>

cherry picked from commit 302170a4b47e869372974abd885dd11d5536b64a

get_dvb_firmware: update script for new location of sp8870 firmware

This url is no longer valid:
http://www.technotrend.de/new/217g/tt_Premium_217g.zip

Replace with:
http://www.softwarepatch.pl/9999ccd06a4813cb827dbb0005071c71/tt_Premium_217g.zip

Thanks-to: Tobias Stoeber <tobi@to-st.de>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/dvb/get_dvb_firmware |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -56,7 +56,7 @@ syntax();
 
 sub sp8870 {
     my $sourcefile = "tt_Premium_217g.zip";
-    my $url = "http://www.technotrend.de/new/217g/$sourcefile";
+    my $url = "http://www.softwarepatch.pl/9999ccd06a4813cb827dbb0005071c71/$sourcefile";
     my $hash = "53970ec17a538945a6d8cb608a7b3899";
     my $outfile = "dvb-fe-sp8870.fw";
     my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);

-- 

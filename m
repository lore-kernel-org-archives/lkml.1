Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbYLNRuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbYLNRuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 12:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYLNRuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 12:50:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:39870 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750963AbYLNRuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 12:50:05 -0500
X-Authenticated: #34473864
X-Provags-ID: V01U2FsdGVkX1978Es3Med7JFQYeDJXtJ63/HldDX+GngyLA13vwN
	QWnrLINfB3sk+T
Message-ID: <49454749.2030901@gmx.de>
Date: Sun, 14 Dec 2008 18:50:01 +0100
From: Philipp Kohlbecher <xt28@gmx.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: documentation fix regarding boot protocol
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/x86/boot.txt describes payload_offset as the offset
from the end of the real-mode code. In fact, it is more accurately
described as the offset from the beginning of the protected-mode
code, as (a) this is how it is actually calculated and (b) the padding
after the real-mode code is not included in the offset.

Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>

---

  Documentation/x86/boot.txt |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 83c0033..414b6fb 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -537,8 +537,8 @@ Type:		read
  Offset/size:	0x248/4
  Protocol:	2.08+

-  If non-zero then this field contains the offset from the end of the
-  real-mode code to the payload.
+  If non-zero then this field contains the offset from the beginning
+  of the protected-mode code to the payload.

    The payload may be compressed. The format of both the compressed and
    uncompressed data should be determined using the standard magic

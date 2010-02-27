Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968032Ab0B0JEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:04:40 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:49599 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968007Ab0B0JEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:04:38 -0500
X-Greylist: delayed 1721 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Feb 2010 04:04:37 EST
Message-ID: <4B88D956.1090003@st.com>
Date: Sat, 27 Feb 2010 14:05:34 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: [PATCH] CLKDEV: remove extra clk_find iterations
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/common/clkdev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

=======================================

diff --git a/arch/arm/common/clkdev.c b/arch/arm/common/clkdev.c
index aae5bc0..736dfba 100644

--- a/arch/arm/common/clkdev.c

+++ b/arch/arm/common/clkdev.c

@@ -55,7 +55,10 @@

static·struct·clk·*clk_find(const·char·*dev_id,·const·char·*con_id)
» » if·(match·==·0)
» » » continue;
+» » if·(match·==·3)
+» » » return·p->clk;
+
» » if·(match·>·best)·{
» » » clk·=·p->clk;
» » » best·=·match;

-- 1.6.0.2






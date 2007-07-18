Return-Path: <linux-kernel-owner+w=401wt.eu-S936357AbXGRTCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936357AbXGRTCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbXGRTCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:02:36 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:48225 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756169AbXGRTCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:02:35 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Revert part of 3f1b0e1f287547903f11fa1e6de7d2765597766e
Date: Wed, 18 Jul 2007 22:01:45 +0300
User-Agent: KMail/1.9.7
Cc: adobriyan@sw.ru, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <200707182103.13500.caglar@pardus.org.tr> <20070718185211.GA5575@martell.zuzino.mipt.ru>
In-Reply-To: <20070718185211.GA5575@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707182201.47434.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

18 Tem 2007 Çar tarihinde, Alexey Dobriyan şunları yazmıştı: 
> *.orig are generated even if line numbers change a bit, so untrusted is
> a somewhat exaggerated.

:), although i prefer previous one, what about something like following?


With 3f1b0e1f287547903f11fa1e6de7d2765597766e Linus's current git tree starts 
to ignore any *.rej files (for example "git status" cannot show what are 
they) but if there are some *.rej files exists, for whatever reason, that 
means some unresolved merge conflicts occured for that code tree and this 
tree is no longer trusted so better not to ignore this.

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
 
 .gitignore |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/.gitignore b/.gitignore
index 8d15830..e3a56e4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -47,4 +47,3 @@ series
 cscope.*
 
 *.orig
-*.rej

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!

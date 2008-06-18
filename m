Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYFRIp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYFRIp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 04:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYFRIpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 04:45:20 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:43059 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632AbYFRIpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 04:45:19 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Userspace tools for BSD process accounting (v3)
Date: Wed, 18 Jun 2008 11:45:13 +0300
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
References: <e2e108260806180134u43413ef5ke226745a8a911e7b@mail.gmail.com> <200806181139.06612.caglar@pardus.org.tr>
In-Reply-To: <200806181139.06612.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806181145.14265.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

18 Haz 2008 Çar tarihinde, S.Çağlar Onur şunları yazmıştı: 
> 18 Haz 2008 Çar tarihinde, Bart Van Assche şunları yazmıştı: 
> > The file init/Kconfig in the kernel source tree refers to the URL
> > http://www.physik3.uni-rostock.de/tim/kernel/utils/acct/ as the
> > download location for userspace tools for processing the v3 BSD
> > process accounting file format. This URL is no longer valid
> > unfortunately. Anyone any idea where these tools can be downloaded ?
> 
> http://savannah.gnu.org/projects/acct/

Following patch corrects URL of "The GNU Accounting Utilities" in init/Kconfig.

Noticed by: Bart Van Assche" <bart.vanassche@gmail.com>

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6199d11..10077ce 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -171,7 +171,7 @@ config BSD_PROCESS_ACCT_V3
 	  process and it's parent. Note that this file format is incompatible
 	  with previous v0/v1/v2 file formats, so you will need updated tools
 	  for processing it. A preliminary version of these tools is available
-	  at <http://www.physik3.uni-rostock.de/tim/kernel/utils/acct/>.
+	  at <http://www.gnu.org/software/acct/>.
 
 config TASKSTATS
 	bool "Export task/process statistics through netlink (EXPERIMENTAL)"
 


Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!

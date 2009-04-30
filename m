Return-Path: <linux-kernel-owner+w=401wt.eu-S1761173AbZD3MRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761173AbZD3MRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 08:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZD3MRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 08:17:35 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44058 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbZD3MRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 08:17:35 -0400
Message-Id: <1241093854.6754.1313086299@webmail.messagingengine.com>
X-Sasl-Enc: 5W2hKAv7YWGIadi5QjdoyKXkG7IIR4nxhd9Wj45XY/1X 1241093854
From: "Jack Stone" <jwjstone@fastmail.fm>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <20090430083348.GA4313@n2100.arm.linux.org.uk>
References: <1241080135.32735.1313058447@webmail.messagingengine.com>
 <20090430083348.GA4313@n2100.arm.linux.org.uk>
Subject: Re: Arm and allyesconfig, allnoconfig, allmodconfig and randconfig
Date: Thu, 30 Apr 2009 14:17:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Apr 2009 09:33 +0100, "Russell King - ARM Linux"
<linux@arm.linux.org.uk> wrote:
> Patches welcome.

Is this the sort of thing you meant? I don't know if the text or
location is correct so comments are very welcome.

Thanks,

Jack

Document that ARM doesn't support all*config

From: Jack Stone <jwjstone@fastmail.fm>

ARM doesn't support all*config. This is because it does not make sense
as
there are so many different variants. Instead the defconfigs should be
used.

Signed-off-by: Jack Stone <jwjstone@fastmail.fm>
---

 Documentation/arm/README |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/arm/README b/Documentation/arm/README
index d98783f..8239e5f 100644
--- a/Documentation/arm/README
+++ b/Documentation/arm/README
@@ -36,6 +36,9 @@ Compilation of kernel
   (arch/arm/boot/Image).  A compressed image can be built by doing a
   'make zImage' instead of 'make Image'.

+  NOTE: ARM Linux doesn't support the all*config targets. This is
because of
+    the number of variants supported. The defconfig targets should be
used
+    instead.

 Bug reports etc
 ---------------

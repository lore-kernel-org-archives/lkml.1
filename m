Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbYJHTlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbYJHTlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbYJHTkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:3991 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbYJHTkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qHDuxxotyoxuvMRMW4RZ/GWynU34O8h6D97t4xqQvMC4zHb03Z4uZFCMLnGX9LG5Xt
         6mX/LFx/npv9zRbkMR5cyHia4pyNL7uWcql3t0IROw42NF4qjmy1T6k0pq7jkIAb36ka
         wJDQEZzr9kcC6G0ltKX/Nw3J/zTUxGDwamr/M=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 03/10] ixj: Unify comments in preparation for pushing duplicate code into a function.
Date: Wed,  8 Oct 2008 14:41:38 -0600
Message-Id: <c0839cc2716ec89be7e165ad0d50b6bcf9be00db.1223497216.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <a04aa1aa0a991f7ea2b0bd9649e4197e30b14ac9.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
 <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
 <a04aa1aa0a991f7ea2b0bd9649e4197e30b14ac9.1223497216.git.aciddeath@gmail.com>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/telephony/ixj.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index e98bac8..99d6bed 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -8705,7 +8705,7 @@ static void DAA_Coeff_Japan(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[2] = 0x7A;
 	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[1] = 0x0A;
 	j->m_DAAShadowRegs.COP_REGS.COP.RingerImpendance_2[0] = 0xD5;
-/* Levelmetering Ringing           (0D):AA,35,0F,8E    ; 25Hz 30V ????????? */
+/* Levelmetering Ringing       (0D):AA,35,0F,8E     ; 25Hz 30V less possible? */
 	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[3] = 0xAA;
 	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[2] = 0x35;
 	j->m_DAAShadowRegs.COP_REGS.COP.LevelmeteringRinging[1] = 0x0F;
-- 
1.5.6.4


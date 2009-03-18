Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbZCRVoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbZCRVoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbZCRVmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:42:14 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756278AbZCRVmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:42:13 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 54/57] microblaze_v7: Kbuild file
Date: Wed, 18 Mar 2009 21:31:21 +0100
Message-Id: <50253611a0770c1ae6a63702208cfb9f96cd1f1a.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <e5b88f50c39aa95431f5ecdb032c6676399ae198.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
 <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
 <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
 <aa044d06327435cee76599fb6220630007f38ba7.1237407249.git.monstr@monstr.eu>
 <99fdae6e9b1da3ae5e2d3ebc841d1afdc694dfae.1237407249.git.monstr@monstr.eu>
 <29d86e7cd1124e596c9dde627f397ca98dccf572.1237407249.git.monstr@monstr.eu>
 <827e2a6a349e009f6c98f31178ce84042b0e2e10.1237407249.git.monstr@monstr.eu>
 <6eb167a9a027d644f10b843b8b1bde66e4c2ee25.1237407249.git.monstr@monstr.eu>
 <592d2a1c72581b6abf73841e640e7b7306c3ec3b.1237407249.git.monstr@monstr.eu>
 <fde2defbb60d9476df3aac0dc7d87241ed247d3e.1237407249.git.monstr@monstr.eu>
 <cde249b42d873cf948bd37d5e997307207de1bd3.1237407249.git.monstr@monstr.eu>
 <1165ce05edc67098d818cf42fd41a621868ab2a6.1237407249.git.monstr@monstr.eu>
 <35b0490d6a70779bdf2e2f55265c7c70a0dcbf1a.1237407249.git.monstr@monstr.eu>
 <1ca9913fc2b9ec220fdb9909f7929abfc38e41b1.1237407249.git.monstr@monstr.eu>
 <4a7e63a56ea0490013724ffddb9f824caafdcbc6.1237407249.git.monstr@monstr.eu>
 <6d67a197ab9f953b93ef151d9a4a198ba0730ef5.1237407249.git.monstr@monstr.eu>
 <d6fb0da1d4e4e5ac85ddca0ee61b81d3da8e95c5.1237407249.git.monstr@monstr.eu>
 <7342f6af4eb95f5bc2cd89a196ab33a3ddc4d5c1.1237407249.git.monstr@monstr.eu>
 <46a9b066a95fad763f6c12044dbc3cd580681fb9.1237407249.git.monstr@monstr.eu>
 <5f12a0cd5bd492df05689715eb73b03b2a07f5d4.1237407249.git.monstr@monstr.eu>
 <1e1dc8ccd5abc4e51272f52465c6b9e5f847f947.1237407249.git.monstr@monstr.eu>
 <14c123f2bae10a8b5fb76cd059ba105c212776ef.1237407249.git.monstr@monstr.eu>
 <4947b1131c14c1526b81493f461606018bd0f090.1237407249.git.monstr@monstr.eu>
 <46bc9a74719cb3c21dfdd558b93bec8c5b5675d8.1237407249.git.monstr@monstr.eu>
 <d3f49195b8f675db48d2eda4f09fddb51af6f946.1237407249.git.monstr@monstr.eu>
 <34c2f9e50610e147be556607e482b88fd674b887.1237407249.git.monstr@monstr.eu>
 <15f6f10873f7c6f4f3b06f9d4d5af3ee9714f873.1237407249.git.monstr@monstr.eu>
 <e5b88f50c39aa95431f5ecdb032c6676399ae198.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/Kbuild |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/Kbuild

diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
new file mode 100644
index 0000000..31820df
--- /dev/null
+++ b/arch/microblaze/include/asm/Kbuild
@@ -0,0 +1,26 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += auxvec.h
+header-y += errno.h
+header-y += fcntl.h
+header-y += ioctl.h
+header-y += ioctls.h
+header-y += ipcbuf.h
+header-y += linkage.h
+header-y += msgbuf.h
+header-y += poll.h
+header-y += resource.h
+header-y += sembuf.h
+header-y += shmbuf.h
+header-y += sigcontext.h
+header-y += siginfo.h
+header-y += socket.h
+header-y += sockios.h
+header-y += statfs.h
+header-y += stat.h
+header-y += termbits.h
+header-y += ucontext.h
+
+unifdef-y += cputable.h
+unifdef-y += elf.h
+unifdef-y += termios.h
-- 
1.5.5.1


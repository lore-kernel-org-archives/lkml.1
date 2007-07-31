Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbXGaHDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbXGaHDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 03:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXGaHDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 03:03:48 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:19958 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXGaHDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 03:03:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from:sender;
        b=s9vh2jGCSbvGeJ80zYNudsB5BHp4z9FKVFIKWwvC8IWdhcjSudfaamshGC5ogXYJOPeE/w4GWmNx1qRWIctM7SkN+Nd8i1J3VOcrNR3zPwg4GtwYekjQpVqbOr0psd7sPV+xoBI/srsTkdKFYaMzMIbZ8G9BXWg4AO7nKvRjD4E=
Date: Tue, 31 Jul 2007 15:03:40 +0800
To: linux-kernel@vger.kernel.org
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Neil Horman <nhorman@tuxdriver.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/3] coredump: cleanup documentation for suid_dumpable
Message-ID: <20070731070340.GB2412@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20070731070238.GA2412@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731070238.GA2412@kernel.sg>
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes documentation that is related to suidsafe core dump
mode.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 Documentation/sysctl/fs.txt |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
index aa986a3..2318f7a 100644
--- a/Documentation/sysctl/fs.txt
+++ b/Documentation/sysctl/fs.txt
@@ -142,12 +142,6 @@ or otherwise protected/tainted binaries. The modes are
 1 - (debug) - all processes dump core when possible. The core dump is
 	owned by the current user and no security is applied. This is
 	intended for system debugging situations only. Ptrace is unchecked.
-2 - (suidsafe) - any binary which normally would not be dumped is dumped
-	readable by root only. This allows the end user to remove
-	such a dump but not access it directly. For security reasons
-	core dumps in this mode will not overwrite one another or
-	other files. This mode is appropriate when administrators are
-	attempting to debug problems in a normal environment.
 
 ==============================================================
 


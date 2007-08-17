Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbXHQJq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbXHQJq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 05:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbXHQJqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 05:46:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:12295 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762727AbXHQJqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 05:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oyLfJ5j29A795suIVrGkNMJ7PsqgbOE/ZxMWSV2i40MXJN0g+zgxh106n2/8TiPZ0QA0TQmRVfQq9CQqjjJeihMrqmL4Y8BUockEKsqHilB0pIP3MoDfp6s2vSntlopcgy7G5gbwh49UHzN7TOTSmbzFdJKFb4WXnkOG8VVKqC4=
Message-ID: <653402b90708170246t2c826e01o23b42bc157f563bc@mail.gmail.com>
Date: Fri, 17 Aug 2007 11:46:23 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Cc: "Pavel Machek" <pavel@ucw.cz>, "Kyle Moffett" <mrmacman_g4@mac.com>,
       linux-security-module@vger.kernel.org,
       "LKML Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <638227.18984.qm@web36610.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070816205833.GC4949@ucw.cz>
	 <638227.18984.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, at:

diff -uprN -X linux-2.6.22-base/Documentation/dontdiff
linux-2.6.22-base/security/smack/Kconfig
linux-2.6.22/security/smack/Kconfig
--- linux-2.6.22-base/security/smack/Kconfig    1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.22/security/smack/Kconfig 2007-07-10 01:08:05.000000000 -0700
@@ -0,0 +1,10 @@
+config SECURITY_SMACK
+       bool "Simplified Mandatory Access Control Kernel Support"
+       depends on NETLABEL && SECURITY_NETWORK
+       default n
+       help
+         This selects the Simplified Mandatory Access Control Kernel.
+         SMACK is useful for sensitivity, integrity, and a variety
+          of other madatory security schemes.
+         If you are unsure how to answer this question, answer N.
+

change:

+          of other madatory security schemes.

to:

+          of other mandatory security schemes.

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm

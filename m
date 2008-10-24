Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYJXOMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYJXOMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYJXOMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:12:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:60088 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYJXOMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:sender;
        b=pQ3HOX3+7TTrdYI4vndKyb/rMGcYHnLaBBDmfWqKnT6bHxg+jUPwXIwnHV3qi7ml75
         SDsJTZYgW5fbYEvo3Adf4NFWesEB6C7FjHPEgawhA+ADijNcKosElxss8+TAo4dUsOlp
         SRNlWnvvPbFkzfJOHtNk5Ec8cFN/4tGy+XhxA=
Date: Fri, 24 Oct 2008 10:10:42 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Update stable tree documentation
Message-ID: <20081024141042.GB2299@yoda.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation for the stable tree rules to reflect
that device IDs and quirks are also suitable for -stable
kernels.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

---

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index 4cfc788..a452227 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -12,6 +12,7 @@ Rules on what kind of patches are accepted, and which ones are not, into the
    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
    security issue, or some "oh, that's not good" issue.  In short, something
    critical.
+ - New device IDs and quirks are also accepted.
  - No "theoretical race condition" issues, unless an explanation of how the
    race can be exploited is also provided.
  - It cannot contain any "trivial" fixes in it (spelling changes,

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYJTTbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYJTTbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYJTTbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:31:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:13824 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbYJTTbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=XeAacFpLFVjFnHL9NuQnyL3LY5Dw0jDbYY5ViMDzf02okSPoV3R3Kk+TJqDJBEG6WP
         HIqPl6w2EzCvDR7meTkqD64sU9xII9U31J2j0h4jT/P1PEUkLGfqQ48y6D3+j8U3zE9a
         BZ0e9hFObS3azL1gxdJ+uPZ1a5vxyHMRzvqc8=
From: Dotan Barak <dotanba@gmail.com>
To: apw@uk.ibm.com
Subject: checkpatch.pl print the line twice when trailing statements in the same line
Date: Mon, 20 Oct 2008 20:51:38 +0200
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810202051.38694.dotanba@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I executed checkpatch.pl version 0.24 on a file and i noticed that when
a tailing statement is being declared at the same line with "while, checkpatch
prints the erroneous line twice.

Here is an example of the output:

ERROR: trailing statements should be on next line
#651: FILE: idbm.c:651:
+               while (*nl && isspace(c = *nl)) nl++;
+               while (*nl && isspace(c = *nl)) nl++;

Is this is the expected behavior?

Thanks
Dotan

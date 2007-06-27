Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbXF0Ly6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbXF0Ly6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbXF0Lyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:54:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:1596 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbXF0Lyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=H2yRi8ksVLFXg0+Awc+KqhsevHIOSLxgCmnh9QZr/v+uTgxD+YhQFGah28i+xTnYpmfutgusX5LC6eGq75jkdROVkNVaIfvukO2gQ73kRFdB6znAABGQhjOcjT97YBFKRmb33ufqiBaLJ9IiSmFHwrwVRO81T9ii7nYyd1MsRlo=
Message-ID: <5d5443650706270454v443d1ac7qee6475bc31af844f@mail.gmail.com>
Date: Wed, 27 Jun 2007 17:24:48 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: apw@uk.ibm.com
Subject: checkpatch: need space before that '*' (ctx:BxB)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy,

In the following case we may not need space before that "(*)". It
looks like false positive. Please check.

need space before that '*' (ctx:BxB)
#1034: FILE: drivers/video/omap/omapfb.c:968:
+       omapfb_nb->nb.notifier_call = (int (*)(struct notifier_block *,
                                                           ^

-- 
--Trilok Soni

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbXL0IAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbXL0IAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 03:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbXL0IAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 03:00:41 -0500
Received: from namei.org ([69.55.235.186]:52430 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750801AbXL0IAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 03:00:40 -0500
Date: Thu, 27 Dec 2007 18:54:12 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
cc: akpm@osdl.org, morgan@kernel.org, serue@us.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
In-Reply-To: <477321C8.3070004@ak.jp.nec.com>
Message-ID: <Xine.LNX.4.64.0712271847500.8367@us.intercode.com.au>
References: <477321C8.3070004@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007, KaiGai Kohei wrote:


(Please put the patch above the .sig separator).

+       len = strlen(tmp);
+
+       if (ofs >= len)
+               return 0;
+
+       if (len - ofs < count)
+               count = len - ofs;
+
+       rc = copy_to_user(buffer, tmp + ofs, count);
+       if (rc)
+               return rc;
+
+       *ppos += count;

Use simple_read_from_buffer().



- James
-- 
James Morris
<jmorris@namei.org>


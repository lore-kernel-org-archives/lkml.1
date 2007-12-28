Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbXL1G5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbXL1G5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 01:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXL1G5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 01:57:07 -0500
Received: from namei.org ([69.55.235.186]:44250 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751806AbXL1G5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 01:57:06 -0500
Date: Fri, 28 Dec 2007 17:54:53 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
cc: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@osdl.org, morgan@kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
In-Reply-To: <477494C3.2040301@ak.jp.nec.com>
Message-ID: <Xine.LNX.4.64.0712281748240.18737@us.intercode.com.au>
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com>
 <477455A0.7060603@ak.jp.nec.com> <477494C3.2040301@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007, KaiGai Kohei wrote:

> +	snprintf(tmp, sizeof(tmp),
> +		 cap_entry == &cap_entries[0] ? "0x%08x" :  "%u",
> +		 cap_entry->code);
> +	len = strlen(tmp);

You don't need to call strlen(), just use scnprintf() and grab the return 
value.


- James
-- 
James Morris
<jmorris@namei.org>

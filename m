Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZF1WuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZF1WuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZF1WuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:50:00 -0400
Received: from tundra.namei.org ([65.99.196.166]:33359 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZF1WuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:50:00 -0400
Date: Mon, 29 Jun 2009 08:50:00 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, "J.R. Okajima" <hooanon05@yahoo.co.jp>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] integrity: add ima_counts_put (updated)
In-Reply-To: <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com>
Message-ID: <alpine.LRH.2.00.0906290849060.29509@tundra.namei.org>
References: <1246029874-6860-1-git-send-email-zohar@linux.vnet.ibm.com> <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Mimi Zohar wrote:

> This patch fixes an imbalance message as reported by J.R. Okajima.
> The IMA file counters are incremented in ima_path_check. If the
> actual open fails, such as ETXTBSY, decrement the counters to
> prevent unnecessary imbalance messages.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Don't forget to use "Reported-by:" lines for the bug reporter.

Have you tested this using the original test case?


-- 
James Morris
<jmorris@namei.org>

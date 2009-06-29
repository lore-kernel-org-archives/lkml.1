Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbZF2LI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbZF2LI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZF2LIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:08:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59213 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZF2LIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:08:18 -0400
Subject: Re: [PATCH] integrity: add ima_counts_put (updated)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, "J.R. Okajima" <hooanon05@yahoo.co.jp>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <alpine.LRH.2.00.0906290849060.29509@tundra.namei.org>
References: <1246029874-6860-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com>
	 <alpine.LRH.2.00.0906290849060.29509@tundra.namei.org>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 07:08:20 -0400
Message-Id: <1246273700.4054.7.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 08:50 +1000, James Morris wrote:
> On Fri, 26 Jun 2009, Mimi Zohar wrote:
> 
> > This patch fixes an imbalance message as reported by J.R. Okajima.
> > The IMA file counters are incremented in ima_path_check. If the
> > actual open fails, such as ETXTBSY, decrement the counters to
> > prevent unnecessary imbalance messages.
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> Don't forget to use "Reported-by:" lines for the bug reporter.

Ok

> Have you tested this using the original test case?

Yes, the patch resolves the iint_free() message.

Mimi


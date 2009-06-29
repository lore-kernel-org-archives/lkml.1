Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZF2Ugw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZF2Ugw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZF2Ugo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:36:44 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:49938 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZF2Ugn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:36:43 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] integrity: add ima_counts_put (updated) 
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1246286783.4054.56.camel@dyn9002018117.watson.ibm.com>
References: <1246029874-6860-1-git-send-email-zohar@linux.vnet.ibm.com> <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com> <12000.1246284749@jrobl> <1246286783.4054.56.camel@dyn9002018117.watson.ibm.com>
Date: Tue, 30 Jun 2009 05:36:29 +0900
Message-ID: <7959.1246307789@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mimi Zohar:
> This suggestion has been mentioned before; and yes would definitely
> resolve the annoying imbalance and iint_free() messages.  But
> incrementing/decrementing the pointers automatically each time a file is
> opened/closed would defeat their purpose - alerting us that a file was
> possibly not measured before being read/executed. 

I may be wrong since I don't fully understand IMA's purpose, but why did
you create ima_counts_get() and make it call after dentry_open() in
nfsd_open()? Isn't it same thing essentially?


J. R. Okajima

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbXD2Hfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbXD2Hfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbXD2Hfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:35:51 -0400
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:60963 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbXD2Hfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:35:50 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Apr 2007 03:35:49 EDT
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH] crypto: Use padlock.ko only as a module
Date: Sun, 29 Apr 2007 09:28:56 +0200
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herbert@gondor.apana.org.au
References: <463379FA.9080004@simon.arlott.org.uk> <20070428153707.50f1644a.randy.dunlap@oracle.com> <4633D6E3.5060602@simon.arlott.org.uk>
In-Reply-To: <4633D6E3.5060602@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704290928.57764.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

On Sunday 29 April 2007, Simon Arlott wrote:
> Ideally I'd just remove that module completely, all it does is 
> trigger the loading of the other two modules when modules are 
> used - so I'll submit a patch for that instead.

That's much better! 

When you force a feature to be a module on a kernel without 
module support, it will effectivly be disabled.

And if it is so simple to do the same in userspace like you suggest,
than that's much better.

Best Regards

Ingo Oeser

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYAIDvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYAIDvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYAIDvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:51:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:48629 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYAIDvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:51:24 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: pnpacpi : exceeded the max number of IO resources
Date: Tue, 8 Jan 2008 22:50:50 -0500
User-Agent: KMail/1.9.5
Cc: yakui.zhao@intel.com, shaohua.li@intel.com,
       Chris Holvenstot <cholvenstot@comcast.net>,
       linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com,
       bjorn.helgaas@hp.com, trenn@suse.de, Andrew Morton <akpm@osdl.org>
References: <1196428488.7066.6.camel@localhost> <47508D3C.9050507@keyaccess.nl> <475436A3.90906@keyaccess.nl>
In-Reply-To: <475436A3.90906@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801082250.51026.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Well, yes, the warning is actually new as well. Previously your kernel 
> > just silently ignored 8 more mem resources than it does now it seems.
> > 
> > Given that people are hitting these limits, it might make sense to just 
> > do away with the warning for 2.6.24 again while waiting for the dynamic 
> > code?
> 
> Ping. Should these warnings be reverted for 2.6.24?

No. I don't think hiding this issue again is a good idea.
I'd rather live with people complaining about an addition dmesg line.

-Len


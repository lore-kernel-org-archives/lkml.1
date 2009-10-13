Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbZJMRUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbZJMRUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760661AbZJMRUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:20:14 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:50987 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760066AbZJMRUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:20:13 -0400
From: Frans Pop <elendil@planet.nl>
To: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: Re: (Solved) Problem compile kernel on Ubuntu and using on Debian
Date: Tue, 13 Oct 2009 19:19:31 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, sam@ravnborg.org
References: <1255431677.13607.118.camel@localhost.localdomain>
In-reply-To: <1255431677.13607.118.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910131919.32560.elendil@planet.nl>
X-OriginalArrivalTime: 13 Oct 2009 17:19:32.0999 (UTC) FILETIME=[54965970:01CA4C29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Dangaard Brouer wrote:
> If you get past this one, by compiling enough modules into the kernel,
> BUT then a lot of modules does not seem to be loaded (modprobe).
[...] 
> Q: I don't know why a depmod update is required, anyone feel free to
> answer that question?

The most likely reason is that the two systems have different, and 
incompatible, versions of module-init-tools.

I've seen the same problem in the past [1] and, after a hefty discussion, 
accepted that you just _have_ to always run depmod -a after installing a 
kernel and before generating an initrd.

Cheers,
FJP

[1] http://bugs.debian.org/518407

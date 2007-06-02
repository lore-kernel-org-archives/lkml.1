Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbXFBRJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbXFBRJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 13:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760623AbXFBRJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 13:09:11 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55356 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760610AbXFBRJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 13:09:09 -0400
Date: Sat, 2 Jun 2007 19:08:22 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Amin Azez <azez@ufomechanic.net>
cc: Netfilter Developer Mailing List 
	<netfilter-devel@lists.netfilter.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xt_gateway match (kernel,2)
In-Reply-To: <Pine.LNX.4.61.0706021856200.5076@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0706021906290.5076@yvahk01.tjqt.qr>
References: <46604D8B.7030507@ufomechanic.net> <Pine.LNX.4.61.0706021337370.21057@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0706021856200.5076@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 2 2007 18:56, Jan Engelhardt wrote:
>---
> include/linux/netfilter/xt_gateway.h |   13 +++++
> net/netfilter/Kconfig                |    9 +++
> net/netfilter/Makefile               |    1 
> net/netfilter/xt_gateway.c           |   85 +++++++++++++++++++++++++++++++++++
> 4 files changed, 108 insertions(+)

A MODULE_ALIAS was missing, causing iptables/netfilter not to autoload 
the module.
SVN tree¹ updated (grab the refreshed patch from there, not reposting 
for this minimal change).


	Jan
-- 
[¹] https://dev.computergmbh.de/svn/misc_kernel/xt_gateway/trunk/

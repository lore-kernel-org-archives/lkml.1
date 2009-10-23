Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbZJWOwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbZJWOwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZJWOwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:52:03 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:57887 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZJWOwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:52:02 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC/PATCH] ratelimit: make output more useful
Date: Fri, 23 Oct 2009 16:51:39 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-tip-tip-01652-g1846719-dirty; KDE/4.3.1; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200910191706.42223.borntraeger@de.ibm.com> <200910231458.11832.borntraeger@de.ibm.com> <20091023131114.GB27097@elte.hu>
In-Reply-To: <20091023131114.GB27097@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910231651.39172.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 23 Oktober 2009 15:11:14 schrieb Ingo Molnar:
> btw., an effect of this will be a small amount of extra bloat at every
> callsite of printk_ratelimit(). There's 200 of them kernel-wide, so i
> guess it's OK as all these codepaths are atypical slowpaths already.

Well, this patch is definitely no high priority.
Maybe you could keep it in tip for a while and see if somebody complains?

Christian

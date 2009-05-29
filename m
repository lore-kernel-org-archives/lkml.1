Return-Path: <linux-kernel-owner+w=401wt.eu-S1762981AbZE2T4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762981AbZE2T4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbZE2T4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:56:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41742 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbZE2T4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:56:16 -0400
Date: Fri, 29 May 2009 22:03:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org, apw@canonical.com
Subject: Re: [tip:x86/mce3] x86, mce: trivial clean up for mce_intel_64.c
Message-ID: <20090529200305.GC1065@one.firstfloor.org>
References: <tip-61a021a0700c22ee527d73d92f9acb109ff478f8@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-61a021a0700c22ee527d73d92f9acb109ff478f8@git.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> x86, mce: trivial clean up for mce_intel_64.c
> 
> Fix for:
> 
> WARNING: space prohibited between function name and open parenthesis '('
> +       for_each_online_cpu (cpu) {

Sorry but that's just a bogus change. That's a loop and we always
put spaces between the loop keyword and its condition.

Just because checkpatch.pl is too dumb to understand that is no
reason to make the code worse like that.

-Andi

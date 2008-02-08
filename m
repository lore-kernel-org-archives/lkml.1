Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbYBHPwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbYBHPwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbYBHPwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:52:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbYBHPwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:52:31 -0500
Date: Fri, 8 Feb 2008 10:52:04 -0500
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org, mingo@elte.hu,
       fche@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] make pr_debug() dynamic
Message-ID: <20080208155204.GB13650@redhat.com>
References: <20080207210320.GA14732@redhat.com> <1202424134.27394.42.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202424134.27394.42.camel@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 02:42:14PM -0800, Joe Perches wrote:
> On Thu, 2008-02-07 at 16:03 -0500, Jason Baron wrote:
> > make the pr_debug() function dependent upon the new immediate infrastruture.
> 
> What's wrong with klogd -c 8 or equivalent?
> 
> 

Setting the loglevel higher, will not make pr_debug() calls visible. The only
way to make them visible right now, is by re-compiling the kernel.

-Jason



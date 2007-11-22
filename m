Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbXKVDw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbXKVDw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 22:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXKVDws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 22:52:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbXKVDwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 22:52:47 -0500
Date: Wed, 21 Nov 2007 22:52:37 -0500
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Message-ID: <20071122035237.GB15764@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	sam@ravnborg.org, rusty@rustcorp.com.au
References: <20071122343.446909000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122343.446909000@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 03:43:06AM +0100, Andi Kleen wrote:

 > There seems to be rough consensus that the kernel currently has too many 
 > exported symbols. A lot of these exports are generally usable utility 
 > functions or important driver interfaces; but another large part are functions
 > intended by only one or two very specific modules for a very specific purpose.
 > One example is the TCP code. It has most of its internals exported, but 
 > only for use by tcp_ipv6.c (and now a few more by the TCP/IP congestion modules) 
 > But it doesn't make sense to include these exported for a specific module
 > functions into a broader "kernel interface".   External modules assume
 > they can use these functions, but they were never intended for that.
 > 
 > This patch allows to export symbols only for specific modules by 
 > introducing symbol name spaces. A module name space has a white
 > list of modules that are allowed to import symbols for it; all others
 > can't use the symbols.

I really like this patchset.   Definitely a step in the right direction imo.
Looks like some nits there that checkpatch will probably pick up on,
but otherwise, looks very straightforward too.

Kudos.

	Dave

-- 
http://www.codemonkey.org.uk

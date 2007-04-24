Return-Path: <linux-kernel-owner+w=401wt.eu-S965254AbXDXVNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254AbXDXVNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXDXVNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:13:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965254AbXDXVND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:13:03 -0400
Date: Tue, 24 Apr 2007 17:12:53 -0400
From: Dave Jones <davej@redhat.com>
To: William Heimbigner <icxcnika@mar.tar.cc>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] cpufreq: allow full selection of default governors
Message-ID: <20070424211253.GG23598@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	William Heimbigner <icxcnika@mar.tar.cc>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0704242057430.25153@server.thyself>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704242057430.25153@server.thyself>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 09:03:23PM +0000, William Heimbigner wrote:
 > The following patches should allow selection of conservative, powersave, and 
 > ondemand in the kernel configuration.

This has been rejected several times already.
Ondemand and conservative isn't a viable governor for all cpufreq implementations
(ie, ones with high switching latencies).  Also, see the comment in the Kconfig
a few lines above where you are adding this.

	Dave

-- 
http://www.codemonkey.org.uk

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbXJFRRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbXJFRRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 13:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbXJFRQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 13:16:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbXJFRQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 13:16:58 -0400
Date: Sat, 6 Oct 2007 13:16:46 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
Message-ID: <20071006171646.GC14375@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr> <20071006110835.GA24463@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006110835.GA24463@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 01:08:35PM +0200, Ingo Molnar wrote:

 > feature request: would be interesting to have a color table (defined in 
 > the .config) dependent on message loglevel. That way KERN_CRIT messages 
 > could be red, KERN_INFO ones white, etc.

If we do this, please let there be a CONFIG_ option to turn it off (and that
should probably be the default too).  Bootup text looking like a fruit salad
doesn't really sound like something that will make debugging any easier.

	Dave

-- 
http://www.codemonkey.org.uk

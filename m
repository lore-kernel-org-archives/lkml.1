Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbZCVGZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbZCVGZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 02:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZCVGZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 02:25:33 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:49666
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbZCVGZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 02:25:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkCABJ3xUnLrQlU/2dsb2JhbAAIgnjQOIN+BmI
X-IronPort-AV: E=Sophos;i="4.38,402,1233500400"; 
   d="scan'208";a="329192206"
Subject: Re: [RFC PATCH 0/3] GPIO switch framework
From: Ben Nizette <bn@niasdigital.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       juha.yrjola@solidboot.com
In-Reply-To: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
References: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 17:25:21 +1100
Message-Id: <1237703121.2720.39.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 15:50 +0200, Jani Nikula wrote:
> Hi -
> 
> This RFC patchset is a pretty straightforward adaptation of OMAP GPIO
> switch framework for mainline integration.
> 
> The GPIO switch framework allows reporting and changing GPIO switches
> via sysfs, with debouncing and sysfs/in-kernel notifications for input
> switches.

OK, so what does this do that /sys/class/gpio/gpioN doesn't currently do
apart from debouncing?  And the output being a string rather than a
simple value (which IMO might be better suited to userspace
interpretation anyway).

I've got a patch, little abandoned at the bottom of my queue, which adds
poll(2) compatibility to the gpiolib sysfs entries [1] and extending
this patch to do debouncing as well would be almost trivial.

I guess what I'm getting at is that this seems like it solves a problem
which has been pretty much solved elsewhere since the OMAP boys wrote
this.

	--Ben.
 
[1] http://marc.info/?l=linux-kernel&m=122454305213792&w=2




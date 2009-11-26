Return-Path: <linux-kernel-owner+w=401wt.eu-S1760019AbZKZBBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbZKZBBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 20:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759916AbZKZBBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 20:01:33 -0500
Received: from mx1.emlix.com ([193.175.82.87]:36524 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbZKZBBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 20:01:33 -0500
Date: Thu, 26 Nov 2009 02:02:34 +0100
From: Johannes Weiner <jw@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] rtc-x1205: fix rtc_time to y2k register value conversion
Message-ID: <20091126010234.GA31257@emlix.com>
References: <1259166736-31006-1-git-send-email-jw@emlix.com> <20091125141100.d9348bd5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125141100.d9348bd5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 02:11:00PM -0800, Andrew Morton wrote:
> I'm thinking that patches 1 and 2 are 2.6.32 material?

Yeah, I think so too, although I hope we can get feedback from the
authors beforehand.

Because #1 looks obvious to me and makes the driver at all usable for
me but the code has been like that since the initial merge in 2006.
So either

	a) nobody ever set the date with this thing,
	b) every embedded linux company has its own private patch or
	c) I am missing something,

where likelyhood is in reverse order.  That makes me feel slightly
uncomfortable.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbYF0SL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbYF0SL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYF0SLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:11:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48512 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYF0SLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:11:47 -0400
Message-ID: <48652D5B.60108@zytor.com>
Date: Fri, 27 Jun 2008 11:11:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Current List of Kernel Summit suggested
 topics from the discuss list
References: <1214577710.3394.14.camel@localhost.localdomain>	<4864FEFB.2050405@linux.intel.com> <200806271035.22856.jbarnes@virtuousgeek.org>
In-Reply-To: <200806271035.22856.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> If we measure quality using bug metrics, things are pretty hard.

One problem with any metric is that the metric becomes a driving factor 
in itself.  Consider the whole whitespace issue, for example.

As far as the whitespace issue is concerned, we may want to consider 
just setting a flag day -- probably immediately before an -rc1 release 
-- and just run "cleanfile" on the whole tree.  In-flux patches are 
still appliable with "patch -l", and by now we should have enough tools 
to avoid adding new whitespace problems, so we can just kill this issue 
once and for all.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYB0IF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYB0IF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 03:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764274AbYB0IFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 03:05:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36063 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764197AbYB0IFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 03:05:20 -0500
Message-ID: <47C519B3.7050200@garzik.org>
Date: Wed, 27 Feb 2008 03:05:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Stephen Hemminger <shemminger@vyatta.com>, romieu@fr.zoreil.com,
       sorbica@icplus.com.tw, jesse@icplus.com.tw,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC/PATCH] ipg: add jumbo frame support kconfig option
References: <Pine.LNX.4.64.0802262148270.12999@sbz-30.cs.Helsinki.FI> <20080226123247.2b63bbf0@extreme> <47C49BDD.50205@garzik.org> <Pine.LNX.4.64.0802270942070.19136@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0802270952050.19294@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0802270952050.19294@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> On Wed, 27 Feb 2008, Pekka J Enberg wrote:
>> Ok, so a sysfs attribute would be sufficient, I suppose?
> 
> s/sysfs attribute/module parameter/

You could do it that way, but really, a non-jumbo default MTU should be 
sufficient.

The user must take proactive action to change the MTU to jumbo at that 
point...  that way its far more likely to get tested, while being 
non-default, too.

	Jeff




Return-Path: <linux-kernel-owner+w=401wt.eu-S1764203AbXFFO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764203AbXFFO2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbXFFO2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:28:07 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:40026 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbXFFO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:28:06 -0400
Date: Wed, 06 Jun 2007 08:28:07 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: spurious completions during NCQ?
In-reply-to: <fa.Nigm+GFAuAW+QzfgqTUfmHJoFfU@ifi.uio.no>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4666C477.1070603@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Nigm+GFAuAW+QzfgqTUfmHJoFfU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florin Iucha wrote:
> Hello,
> 
> I was working on a I/O heavy workload (parsing 100K spam messages to
> extract certain structures) when I got this in the kernel log:

..

> 
> This is on a Thinkpad T60 with 2 GB RAM, running Ubuntu 7.04 (kernel
> 2.6.20-16-generic).  No proprietary drivers (ok, maybe the Intel
> Wi-Fi - but that should not count).
> 
> The laptop came with Windows but I blew that away - did I mess some
> thing up regarding HPA and its ilk?

It means the drive reported command tags were completed that were not 
outstanding. What kind of drive is this?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


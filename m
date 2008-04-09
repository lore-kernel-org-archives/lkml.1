Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYDIOa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYDIOa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 10:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYDIOak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 10:30:40 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:2185 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYDIOaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:30:39 -0400
Date: Wed, 09 Apr 2008 08:32:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: VM - a plenty of inactive memory
In-reply-to: <fa.R/QDJx+PTjNDKcqKW25clMhQ6tg@ifi.uio.no>
To: Andreas Grimm <agrimm61@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
Message-id: <47FCD37B.3040103@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.+S2mzTenrJ0RtdxGRDJkwIoNteA@ifi.uio.no>
 <fa.TNkasVGEvLf8IqduH2+YXFyYR1w@ifi.uio.no>
 <fa.R/QDJx+PTjNDKcqKW25clMhQ6tg@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Grimm wrote:
> Hi Johannes,
> 
> i know this. But why the kernel locks that memory for a so long time
> (2 days now)? Is there a way to enforce the reclaiming? And how can i
> find out, which process owns that memory. The problem is, that i can't
> accept, that the free memory fell down to 50MB, when i have 24GB in
> the nirvana. The system was recently very close to the awkward
> situation to swap to disk, and i bet it will do so in the next few
> days, because it happened before. Unintelligible, if one got that much
> ram.
> 
> Bye, Andreas

The memory should not be locked. If the kernel has no reason to reclaim 
the memory, it won't, though.

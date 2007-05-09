Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbXEIWur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbXEIWur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbXEIWuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:50:32 -0400
Received: from gw.goop.org ([64.81.55.164]:54534 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbXEIWua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:50:30 -0400
Message-ID: <46425039.3090408@goop.org>
Date: Wed, 09 May 2007 15:50:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509215538.GK11115@waste.org> <46424896.8080506@goop.org> <20070509224423.GL11115@waste.org>
In-Reply-To: <20070509224423.GL11115@waste.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
>> Which I am, extensively, but not on the repo that got damaged.  That's
>> why I was wondering about the nlink issues.  If I qpop a bunch of
>> patches after just pushing them, won't it simply truncate the file?
>>     
>
> Yep. But it will break links before doing that. Basically all opens go
> through a function that breaks links.
>   

Well, yes, but I was proposing the theory that xfs was misreporting the
linkcount, which would confuse the link-breaking logic, right?

    J


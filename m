Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYAHXSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYAHXSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbYAHXSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:18:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYAHXSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:18:03 -0500
Message-ID: <4784046B.5000004@redhat.com>
Date: Tue, 08 Jan 2008 18:16:59 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Brice Figureau <brice+lklm@daysofwonder.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Strange freeze on 2.6.22 (deadlock?)
References: <49447.213.41.177.193.1199732765.squirrel@corp.daysofwonder.com>
In-Reply-To: <49447.213.41.177.193.1199732765.squirrel@corp.daysofwonder.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2008 02:06 PM, Brice Figureau wrote:
 
> Thanks for the answer.
> I'm using whatever is the default mount option (which I think is
> data=ordered). The only other mount option I use is nodiratime,noatime.
> 
> Note that a large part of the processes in D state are "waiting" in
> __mutex_lock from generic_file_aio_write.
> Another large part is coming from balance_dirty_pages_ratelimited_nr.
> 
> It seems that there was some writeback congestion to the block device.
> All the /proc/sys/vm/* files are at their defaults.
> 
> This looks like if it wasn't possible to write to the block device anymore.
> Could a block device write error (ie hardware failure) be the root cause?
> 
> Any other idea?
> What should I try the next time it freezes?

Same bug as http://lkml.org/lkml/2007/8/1/469 ??

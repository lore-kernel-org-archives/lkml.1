Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbXFMPLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbXFMPLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 11:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758160AbXFMPKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 11:10:54 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:59872 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbXFMPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 11:10:53 -0400
Message-ID: <467008E9.7070902@nortel.com>
Date: Wed, 13 Jun 2007 09:10:33 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>
CC: John Sigler <linux.kernel@free.fr>, Andrea Arcangeli <andrea@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Runaway process and oom-killer
References: <466FAF99.3070708@free.fr> <20070613090837.GD7443@v2.random> <466FB6E8.8020606@free.fr> <466FF154.7030905@aitel.hist.no>
In-Reply-To: <466FF154.7030905@aitel.hist.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jun 2007 15:10:36.0749 (UTC) FILETIME=[FF0F87D0:01C7ADCC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting wrote:

> My guess:
> Something needs memory but finds there is none to be had
> oom-killer is invoked and targets myapp.
> myapp takes some time to die. Particularly, the memory it uses
> isn't freed up instantly.

Has anyone considered actually bumping up the priority of the task being 
killed so that it gets to run and free up its resources in a timely manner?

We've done some experimenting with actually putting it in SCHED_RR and 
it seems to help (in the case of other busy SCHED_RR tasks on the 
system).  Admittedly we have an older kernel, so behaviour may be 
different now.

Chris

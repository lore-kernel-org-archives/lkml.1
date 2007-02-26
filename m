Return-Path: <linux-kernel-owner+w=401wt.eu-S1161219AbXBZVlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219AbXBZVlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161215AbXBZVlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:41:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:32988 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161219AbXBZVla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:41:30 -0500
Message-ID: <45E353E9.109@redhat.com>
Date: Mon, 26 Feb 2007 16:40:57 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: netconsole module cannot be removed
References: <45E3447F.9080706@redhat.com> <20070226133156.3bfd2a74@freekitty>
In-Reply-To: <20070226133156.3bfd2a74@freekitty>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Mon, 26 Feb 2007 15:35:11 -0500
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
>> Trying to remove netconsole, rmmod goes into a tight loop with
>> 100% CPU usage. It can't be killed with 'kill -9'. Shutdown
>> works, though. Kernel is 2.6.20 FC6 config, and I'm 99.9%
>> sure the module signing has nothing to do with this.
>>
> 
> No it probably has to do with printing a message during module removal.
> 

Yeah that could explain it.

But when I load it after the network has started I can't get it to
output any kernel messages to the network interface, either. I'll
try to reproduce this on a vanilla kernel next...


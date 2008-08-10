Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYHJXws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYHJXws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 19:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYHJXwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 19:52:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40717 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYHJXwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 19:52:40 -0400
Message-ID: <489F7F1D.3030606@zytor.com>
Date: Sun, 10 Aug 2008 16:51:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai.lu@amd.com>,
       Andi Kleen <ak@suse.de>, Glauber Costa <gcosta@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [PATCH] x86:  Restore proper vector locking during cpu
 hotplug
References: <m11w0xu9hd.fsf@frodo.ebiederm.org>
In-Reply-To: <m11w0xu9hd.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Having cpu_online_map change during assign_irq_vector can result
> in some really nasty and weird things happening.  The one that
> bit me last time was accessing non existent per cpu memory for non
> existent cpus.
> 
> This locking was removed in a sloppy x86_64 and x86_32 merge patch.
> 
> Guys can we please try and avoid subtly breaking x86 when we are
> merging files together?

Queuing for tip:x86/urgent.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZCGAP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZCGAP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 19:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZCGAPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 19:15:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZCGAPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 19:15:15 -0500
Message-ID: <49B1BBB8.7010806@zytor.com>
Date: Fri, 06 Mar 2009 16:11:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce bootmem_state
References: <> <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org> <49B0BF46.4080405@zytor.com> <49B19FB4.40909@goop.org> <49B1B2E9.5050507@zytor.com> <49B1BB6F.2080800@goop.org>
In-Reply-To: <49B1BB6F.2080800@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> The total number of states is always going to be subsys1 * subsys2 * 
> ..., but folding them all into one state variable only makes sense if we 
> have a well-defined set of states *and* transitions between them.  But 
> even then it implies that we have enough coupling between our subsystems 
> that we would even care what their aggregate state is, which is already 
> a bad idea.  If we keep the internal workings of our subsystems as 
> internal details, then having private state variables is the way to go.
> 
> The real problem with system_state is that it has a few broadly-defined 
> values, but no real explanation of what they mean, so they end up 
> getting used in inappropriate ways (like the virt_addr_valid() thing I 
> fixed yesterday).
> 

Obviously.

	-hpa


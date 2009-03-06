Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZCFWMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZCFWMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZCFWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:12:09 -0500
Received: from gw.goop.org ([64.81.55.164]:54568 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555AbZCFWMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:12:08 -0500
Message-ID: <49B19FB4.40909@goop.org>
Date: Fri, 06 Mar 2009 14:12:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce bootmem_state
References: <> <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org> <49B0BF46.4080405@zytor.com>
In-Reply-To: <49B0BF46.4080405@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>   
>> Impact: cleanup
>>
>> extend after_bootmem and after_init_bootmem to bootmem_state
>> and will have BEFORE_BOOTMEM, DURING_BOOTMEM, AFTER_BOOTMEM
>>
>>     
>
> Wouldn't it make more sense to add these as system_state enumerations
> and use relational comparisons on them (< <= >= >)?

Please, no.  system_state should be deprecated; its hard enough to have 
a notion of some kind of system-wide state, but putting subsystem 
specific substates into it just makes things worse.

    J

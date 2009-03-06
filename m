Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZCFGQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZCFGQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbZCFGQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:16:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42694 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZCFGQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:16:18 -0500
Message-ID: <49B0BF46.4080405@zytor.com>
Date: Thu, 05 Mar 2009 22:14:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: mingo@elte.hu, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: introduce bootmem_state
References: <> <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org>
In-Reply-To: <49B0640A.5080607@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Impact: cleanup
> 
> extend after_bootmem and after_init_bootmem to bootmem_state
> and will have BEFORE_BOOTMEM, DURING_BOOTMEM, AFTER_BOOTMEM
> 

Wouldn't it make more sense to add these as system_state enumerations
and use relational comparisons on them (< <= >= >)?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYBKFjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYBKFjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYBKFje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:39:34 -0500
Received: from mga06.intel.com ([134.134.136.21]:61217 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbYBKFje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:39:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,332,1199692800"; 
   d="scan'208";a="257364775"
Message-ID: <47AFDF57.9070203@linux.intel.com>
Date: Sun, 10 Feb 2008 21:38:31 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Oops report for the week upto Feb 10th 2008
References: <47AF9867.6050902@linux.intel.com> <20080211053113.GA1736@martell.zuzino.mipt.ru>
In-Reply-To: <20080211053113.GA1736@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Sun, Feb 10, 2008 at 04:35:51PM -0800, Arjan van de Ven wrote:
>> Rank 3: remove_proc_entry
>> 	WARN_ON at fs/proc/generic.c:736
>> 	Reported 20 times (38 total reports)
>> 	This WARN_ON is there if code tries to remove a non-empty /proc 
>> 	directory.
>> 	Most reports are tainted, pointing at a bug in a binary module.
>> 	Without the WARN_ON improvements from 2.6.25-rc1 it'll be hard to 
>> 	figure out which module is guilty.
> 
> Easy, I'll submit patch RSN.

to fix it or to print modules?
(the later is already done in 2.6.25-rc1, just not in 2.6.24 yet)


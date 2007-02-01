Return-Path: <linux-kernel-owner+w=401wt.eu-S932838AbXBAWii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbXBAWii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932861AbXBAWih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:38:37 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:53392 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838AbXBAWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:38:37 -0500
In-Reply-To: <20070201222356.GV1344@kvack.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <20070201130234.GA15257@elte.hu> <5678BC95-E548-414F-85F9-9D6B4DC914EC@oracle.com> <20070201222356.GV1344@kvack.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <54112D52-313E-4EBE-BD72-E2BE592F1E83@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Thu, 1 Feb 2007 14:37:16 -0800
To: Benjamin LaHaise <bcrl@kvack.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Priorities cannot be shared, as they have to adapt to the per-request
> priority when we get down to the nitty gitty of POSIX AIO, as  
> otherwise
> realtime issues like keepalive transmits will be handled incorrectly.

Well, maybe not *blind* sharing.  But something more than the  
disconnect threads currently have with current->ioprio.

Today an existing kernel thread would most certainly ignore a  
sys_ioprio_set() in the submitter and then handle an aio syscall with  
an old current->ioprio.

Something more smart than that is all I'm on about.

- z

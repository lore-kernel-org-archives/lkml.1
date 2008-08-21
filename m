Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYHUK2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYHUK2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbYHUK2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:28:20 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:51651 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757631AbYHUK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:28:19 -0400
Message-ID: <48AD433E.7010905@linux.vnet.ibm.com>
Date: Thu, 21 Aug 2008 15:58:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
       dave@linux.vnet.ibm.com
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu> <20080821073020.GA28386@elte.hu>
In-Reply-To: <20080821073020.GA28386@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Oren Laadan <orenl@cs.columbia.edu> wrote:
> 
>>  checkpoint/ckpt_x86.c   |   28 ++++
>>  checkpoint/rstr_x86.c   |    2 +
> 
> please move these into arch/x86/mm/checkpoint.c and 
> arch/x86/mm/restore.c. (also, please dont try to abbreviate too much in 
> filenames, makes it harder to follow changes later on, etc.)
> 
> Cool stuff btw! Any ETA on when more complex apps can be 
> checkpointed/restored? Also, shouldnt at least part of this effort be 
> joined with the live migration efforts of openvz? (or do you see 
> fundamental, unsolvable differences?)

My understanding is that this is a result of the joint discussion (with the
OpenVZ folks present) that happened during the containers min-summit prior to
OLS this year.

-- 
	Balbir

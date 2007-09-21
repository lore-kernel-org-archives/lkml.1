Return-Path: <linux-kernel-owner+w=401wt.eu-S1762670AbXIUTn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762670AbXIUTn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760386AbXIUTnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:43:21 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54888 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbXIUTnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:43:21 -0400
Date: Fri, 21 Sep 2007 20:42:52 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Slava Abramov <slava.abramov@amd.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: ptep_test_and_clear_young() i386 vs. x86_64 
In-Reply-To: <46F4182C.9050202@amd.com>
Message-ID: <Pine.LNX.4.64.0709212039220.5752@blonde.wat.veritas.com>
References: <46F4182C.9050202@amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Slava Abramov wrote:
> 
> Is there any special reason why ptep_test_and_clear_young()
> implementation for x86_64 does not call pte_update()?

Because the i386 pte_update is there for CONFIG_PARAVIRT (and
a no-op without it), and CONFIG_PARAVIRT is so far peculiar to
i386: x86_64 doesn't even define a pte_update to call there.

Hugh

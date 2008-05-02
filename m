Return-Path: <linux-kernel-owner+w=401wt.eu-S935985AbYEBWn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935985AbYEBWn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758278AbYEBWnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:43:46 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:51530 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbYEBWnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:43:45 -0400
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: HELP: Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B1D@NAMAIL2.ad.lsil.com>
	<20080502.153210.122414532.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 May 2008 15:43:32 -0700
In-Reply-To: <20080502.153210.122414532.davem@davemloft.net> (David Miller's
	message of "Fri, 02 May 2008 15:32:10 -0700 (PDT)")
Message-ID: <adaabj8499n.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 22:43:32.0870 (UTC) FILETIME=[F3218260:01C8ACA5]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Is a 64bit write to MMIO registers an atomic operation when using the
 > > writeq API?  
 > 
 > The answer to this question this is platform dependent.
 > 
 > On most 64-bit platforms, it is.  On some 32-bit ones, it is not.

Are there any 32-bit platforms with writeq()?  A quick grep suggests not.

Are there any 64-bit platforms where writeq() allows the MMIO to be
split into multiple cycles from the target device's view?  I've been
coding assuming that at least no other MMIO writes will reach the device
in the middle of a writeq().

 - R.

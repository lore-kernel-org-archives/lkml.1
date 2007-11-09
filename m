Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbXKIBT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbXKIBT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 20:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbXKIBTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 20:19:48 -0500
Received: from igraine.blacknight.ie ([81.17.252.25]:40389 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXKIBTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 20:19:47 -0500
Date: Fri, 9 Nov 2007 00:53:49 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Fitzsimons <robfitz@273k.net>, linux-kernel@vger.kernel.org,
       jblunck@suse.de, ak@suse.de, mingo@elte.hu, tglx@linutronix.de,
       Philippe Elie <phil.el@wanadoo.fr>
Subject: Re: oops in oprofile/dump_trace/X86 with 2.6.24-rcX
Message-ID: <20071109005349.GA2653@localhost>
References: <20071108014527.GA2474@localhost> <20071108105418.8b58306d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108105418.8b58306d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=-1.512, required 7,
	autolearn=disabled, RCVD_IN_NERDS_IE -3.50, RCVD_IN_SORBS_DUL 1.99)
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Philippe, on Sun, 21 Oct you sent a "[patch 1/2] oProfile: oops when
> profile_pc() return ~0LU" which as far as I can tell never got applied.

This patch applied on it own doesn't fix the problem causing my oops.

> I've queued the below revert of Jan's change, in case your lost [2/2] doesn't
> address Robert's oops.
> 
> Robert, can you please test this?

This revert patch applied on it own does fix the oops.

Robert


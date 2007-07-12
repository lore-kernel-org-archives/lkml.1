Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbXGLXQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbXGLXQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759699AbXGLXQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:16:05 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:5274 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759472AbXGLXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:16:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CANtSlkarR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.16,534,1175497200"; 
   d="scan'208"; a="502704628:sNHT28499792"
To: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Further 2.6.23 merge plans...
X-Message-Flag: Warning: May contain useful information
References: <adalkdl43w0.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Jul 2007 16:15:58 -0700
In-Reply-To: <adalkdl43w0.fsf@cisco.com> (Roland Dreier's message of "Thu, 12 Jul 2007 16:07:59 -0700")
Message-ID: <adahco943ip.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jul 2007 23:15:59.0713 (UTC) FILETIME=[9BADED10:01C7C4DA]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As you can see, I just sent my first 2.6.23 pull request for Linus.
There are still a few more things I plan to do in before the merge
window closes (in ~10 days):

 - Write a patch to add P_Key handling to user_mad in the way we
   discussed (add an ioctl to enable P_Key mode without breaking old
   apps) -- I hope to do this tomorrow so we can get some review and
   testing before merging it.

 - Take a look at Sean's local SA caching patches.  I merged
   everything else from Sean's tree, but I'm still undecided about
   these.  I haven't read them carefully yet, but even aside from that
   I don't have a good feeling about whether there's consensus about
   this yet.  Any opinions about merging, for or against, would be
   appreciated here.

 - Merge up pending hardware driver changes, including the cxgb3 and
   ehca patches I have in my queue, plus Jack's catastrophic error
   patch for mlx4.

 - Try to get to resolution on the IPoIB "CM without SRQ" solution.

Also, if there's something I didn't list and didn't already include in
the tree I asked Linus to pull, please remind me.  I probably dropped it.

 - R.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYCUSoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYCUSoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYCUSoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:44:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33153 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbYCUSoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:44:07 -0400
Date: Fri, 21 Mar 2008 19:46:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, andreas.herrmann3@amd.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/7] Readd rdmsrl_safe
Message-ID: <20080321184656.GM2346@one.firstfloor.org>
References: <20080312353.598285931@firstfloor.org> <20080312025331.B113B1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211756000.3781@apollo.tec.linutronix.de> <20080321171636.GE2346@one.firstfloor.org> <alpine.LFD.1.00.0803211857030.3781@apollo.tec.linutronix.de> <20080321180612.GK2346@one.firstfloor.org> <alpine.LFD.1.00.0803211909501.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211909501.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Never mind I retract the clean up patch. While doing the actual
reordering is not that difficult I would need to retest and I don't
have time for that now. And since reordering tends to requiring
typing in everything again and I make occasional typos (and I added
bugs in the past during such reordering exercises) the retesting
would be needed. But for that clean up it is probably not worth it.
After all it just makes the code a little nicer, but doesn't fix
or improve anything. 

Please still consider the other patches in the serioes.

-Andi

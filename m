Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbZCSNq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbZCSNq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZCSNqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:46:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54273 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbZCSNqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:46:16 -0400
Date: Thu, 19 Mar 2009 14:46:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Peter W. Morreale" <pmorreale@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vernon Mauery <vernux@us.ibm.com>,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: High contention on the sk_buff_head.lock
Message-ID: <20090319134649.GX11935@one.firstfloor.org>
References: <49C12E64.1000301@us.ibm.com> <87prge1rhu.fsf@basil.nowhere.org> <1237467559.6926.31.camel@hermosa>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237467559.6926.31.camel@hermosa>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Recall that adaptive spin,developed in RT, is now in mainline. 

For mutexes, but not for spinlocks. And qdisc uses spinlocks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

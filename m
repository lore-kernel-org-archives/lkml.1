Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYHUKH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYHUKH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYHUKHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:07:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43128 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYHUKHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:07:13 -0400
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4
	released
From: Peter Zijlstra <peterz@infradead.org>
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 12:07:11 +0200
Message-Id: <1219313231.8651.101.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 20:50 -0600, jmerkey@wolfmountaingroup.com wrote:

>  volatiles left in the code due to the previously stated
>  (and still present) severe breakage of the GNU compiler with SMP 
>  shared data.  most of the barrier() functions are just plain broken
>  and do not result in proper compiler behavior in this tree. 

Can you provide explicit detail?

By using barrier() the compiler should clobber all its memory and
registers therefore forcing a write/reload of the variable.




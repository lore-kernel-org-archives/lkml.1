Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbYDPObd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbYDPObd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYDPObZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:31:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49301 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYDPObY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:31:24 -0400
Date: Wed, 16 Apr 2008 07:31:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <vda.linux@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Does process need to have a kernel-side stack all the time?
Message-ID: <20080416073110.1a46063f@laptopd505.fenrus.org>
In-Reply-To: <48060625.4040509@firstfloor.org>
References: <200804141547.57719.vda.linux@googlemail.com>
	<87hce4uya8.fsf@basil.nowhere.org>
	<20080416124728.GA5050@elte.hu>
	<20080416065451.78329e12@laptopd505.fenrus.org>
	<48060625.4040509@firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 15:59:01 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> 
> > well that and the fact that RH had customers who had major issues
> > at fewer threads with 8Kb versus fragmentation.
> > on 32 bit with a bunch of ram, there's just not enough lowmem
> > around to not have it fragmented to hell and back.
> 
> 2.6 VM has much more aggressive defrag heuristics than 2.4. That is
> what I meant with likely obsolete.

it's a question of very simple math though; both the space and the
amount of other pinnings mean you run into a wall.

2.6 is no doubt better, for sure it's better in freeing up memory etc.
It just can't be good enough.

(just to be clear, customers do run 30k threads workloads on 16Mb machines that
also have a sizable inode and dentry cache. you just cannot defragment that to the point
that you can use 8k stacks).




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

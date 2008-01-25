Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbYAYCQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbYAYCQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 21:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYAYCQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 21:16:34 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:32931 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbYAYCQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 21:16:34 -0500
Message-ID: <4799467E.6020407@davidnewall.com>
Date: Fri, 25 Jan 2008 12:46:30 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com> <20080122160114.GB23277@does.not.exist> <4798C511.8070305@davidnewall.com> <20080124172414.GD4476@does.not.exist> <4798D10C.6090109@davidnewall.com> <20080124203724.GA14852@one.firstfloor.org>
In-Reply-To: <20080124203724.GA14852@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The performance benefit is trivial,
>>     
>
> That's actually not true when you're talking about potential cache misses.
> Cache misses are very expensive.
>   

They are when in a tight loop, but are trivial in this case.  I'll go
further and say that unless the system is constantly execing, there will
always be a cache miss, and that removing this code will not improve
that at all.

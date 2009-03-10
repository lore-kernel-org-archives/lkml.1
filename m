Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZCJAUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZCJAUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 20:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZCJAUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 20:20:36 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42246 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZCJAUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 20:20:36 -0400
Message-ID: <49B5B249.1010904@davidnewall.com>
Date: Tue, 10 Mar 2009 10:50:25 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Willy Tarreau <w@1wt.eu>
Subject: Re: [patch] Re: scheduler oddity [bug?]
References: <1236448069.16726.21.camel@bzorp.balabit>	 <1236505323.6281.57.camel@marge.simson.net>	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>	 <1236529200.7110.16.camel@marge.simson.net>	 <20090308175255.GA22802@elte.hu>	 <1236585731.6118.24.camel@marge.simson.net>	 <20090309080714.GB24904@elte.hu>  <1236596664.8389.331.camel@laptop>	 <1236604563.6027.8.camel@marge.simson.net>	 <1236605267.8389.490.camel@laptop>  <49B52118.7010509@davidnewall.com> <1236608390.8389.557.camel@laptop>
In-Reply-To: <1236608390.8389.557.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-03-10 at 00:30 +1030, David Newall wrote:
>   
>> Wasn't it reported to be caused by an off-by-one bug in commit 
>> 38736f475071b80b66be28af7b44c854073699cc?
>>     
>
> Completely different issue. Unfortunate interference of effects though.


And yet, there *is* a bug in that commit, being, as I explained, that it
won't return a task if it's the last entry in the list, which seems
quite likely immediately after a fork.  Has my patch been tried?

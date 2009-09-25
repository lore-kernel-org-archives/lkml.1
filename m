Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbZIYVdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbZIYVdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 17:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZIYVdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 17:33:45 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:47933 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZIYVdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 17:33:44 -0400
Message-ID: <4ABD36CE.3080400@nortel.com>
Date: Fri, 25 Sep 2009 15:31:58 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Michael Trimarchi <trimarchi@gandalf.sssup.it>
CC: sat <takeuchi_satoru@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Raistlin <raistlin@linux.it>
Subject: Re: massive_intr on CFS, BFS, and EDF
References: <4ABC068A.6070704@jp.fujitsu.com> <4ABCEABC.4050200@gandalf.sssup.it>
In-Reply-To: <4ABCEABC.4050200@gandalf.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Sep 2009 21:33:41.0043 (UTC) FILETIME=[D9B1B830:01CA3E27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2009 10:07 AM, Michael Trimarchi wrote:
> It is important to note that
> the expected behavior of an edf scheduler is *not* a fair one. It has to
> do its best to guarantee the deadlines of the admitted tasks.

Do you allow oversubscription with EDF?  It would seem so based on these
results.  Would it maybe make sense to disallow oversubscription, or
make it an option?

If you have massive oversubscription with EDF, what is the design
intent?  Do you try to meet the goals on as many tasks as possible,
while the oversubscribed tasks get nothing?

Chris


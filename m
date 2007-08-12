Return-Path: <linux-kernel-owner+w=401wt.eu-S938050AbXHLUEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938050AbXHLUEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759001AbXHLUEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:04:30 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:59107 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012AbXHLUE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:04:29 -0400
Message-ID: <46BF66F4.9030106@gmail.com>
Date: Sun, 12 Aug 2007 22:00:52 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>	<46BE621E.9090509@gmail.com>	<9a8748490708111852y569a3e18i1c3d192e60eceafe@mail.gmail.com>	<46BE7BB6.2010607@gmail.com> <20070812013519.a5d5d59b.akpm@linux-foundation.org>
In-Reply-To: <20070812013519.a5d5d59b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2007 10:35 AM, Andrew Morton wrote:

> On Sun, 12 Aug 2007 05:17:10 +0200 Rene Herman <rene.herman@gmail.com> wrote:

>> The line just below where it does that _does_ seem to have a problem:
>>
>>          /*
>>           * Maximum threshold is 125
>>           */
>>          threshold = min(125, threshold);
>>
>> as either the comment or the code is wrong and it seems it's the code. Added 
>> Andrew Morton to the CC for that.
> 
> Yes, that's inconsistent.  And looking at Christoph's df9ecaba it's unclear
> whether the comment is wrong or the code is wrong.  The code is wrong, I
> expect.

Extremely friendly of you to pretend I wasn't being thick at all but don't 
worry, I can take it. Anyways, since Christoph wasn't in CC on that one:

On 08/12/2007 05:29 AM, Roland Dreier wrote:

> What's the problem? That line sets threshold to the smaller of the 
> current value or 125, which is exactly what one would want to do if the
> maximum value is 125. Just do a couple of examples: eg if threshold is
> 100 going into that line, then the value is left alone; if threshold is
> 150 then it gets set to 125; and that seems exactly correct.

Rene.


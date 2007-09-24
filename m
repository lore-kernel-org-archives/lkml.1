Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbXIXQA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbXIXQA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXIXQAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:00:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51135 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXIXQAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:00:14 -0400
Message-ID: <46F7DEF2.1020104@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2007 10:59:46 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: "Martin J. Bligh" <mbligh@mbligh.org>
CC: Natalie Protasevich <protasnb@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       David Ames <david@linux-foundation.org>
Subject: Re: Urgent bugzilla mainteinance needed
References: <20070923195821.cab02f42.diegocg@gmail.com>	 <32209efe0709231108v459c3559xf247db2c122513c0@mail.gmail.com>	 <1190572240.22181.2.camel@shinybook.infradead.org> <32209efe0709231134t1dda4965i6e1d49a8d134c664@mail.gmail.com> <46F72D80.20504@mbligh.org>
In-Reply-To: <46F72D80.20504@mbligh.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin J. Bligh wrote:
> Natalie Protasevich wrote:
>> On 9/23/07, David Woodhouse <dwmw2@infradead.org> wrote:
>>> On Sun, 2007-09-23 at 11:08 -0700, Natalie Protasevich wrote:
>>>> On 9/23/07, Diego Calleja <diegocg@gmail.com> wrote:
>>>>> Take a look at http://bugzilla.kernel.org/show_bug.cgi?id=3710
>>>>>
>>>>> bugzilla tries to send a mail to the reporter, it fails ("unknown
>>>>> user account"),
>>>>> but the error failure is appended as a bugzilla comment. Then
>>>>> bugzilla tries to
>>>>> send that comment to everyone involved in the bug, including the
>>>>> reporter,
>>>>> so it fails again.....Houston, we've a endless loop.
>>>>>
>>>>> There're 540 comments in that bug report already, and the
>>>>> bugme-daemon
>>>>> mail list is being spammed....
>>>> I just sent emails to those who maintain bugzilla software and systems
>>>> that run it, hope someone will be online soon to help alleviate
>>>> this...
>>> Bugzilla really shouldn't be accepting any mail with empty reverse-path
>>> (MAIL FROM:<>)
Updated to handle this case.
>>
>> Ah, then should be easy fix then. I don't have access to the system
>> though, will have to helplessly wait until one of the guys picks up...
>> :(
>
> Sorry, can't fix this - I don't have direct access to the system,
> and I don't think the others will be back until Monday ;-(
>
> M.
It should be working now.  Thanks to David Ames for handling the mailer
part.  I cleaned the spam(1353 msgs) out of the bug.

Jon


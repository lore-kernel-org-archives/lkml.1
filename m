Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbXH1EsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbXH1EsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 00:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXH1EsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 00:48:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34971 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbXH1EsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 00:48:10 -0400
Message-ID: <46D3A8AD.6000701@oracle.com>
Date: Mon, 27 Aug 2007 21:46:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: "Michael J. Evans" <mjevans1983@comcast.net>
CC: Michael Evans <mjevans1983@gmail.com>, Neil Brown <neilb@suse.de>,
       Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
References: <200708222058.45480.mjevans1983@comcast.net> <200708271516.21889.mjevans1983@comcast.net> <20070827153020.43788e21.randy.dunlap@oracle.com> <200708272138.19785.mjevans1983@comcast.net>
In-Reply-To: <200708272138.19785.mjevans1983@comcast.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael J. Evans wrote:
> On Monday 27 August 2007, Randy Dunlap wrote:
>> On Mon, 27 Aug 2007 15:16:21 -0700 Michael J. Evans wrote:
>>
>>> =============================================================
>>> --- linux/drivers/md/md.c.orig	2007-08-21 03:19:42.511576248 -0700
>>> +++ linux/drivers/md/md.c	2007-08-21 04:30:09.775525710 -0700
>>> @@ -24,4 +24,6 @@
>>>
>>> +   - autodetect dev list not array: Michael J. Evans 
> <mjevans1983@gmail.com>
>>> +
>> Nowadays we use an SCM for such comments, not the source file(s).
> 
> SCM?  Is this automatic, where do I go to see it?

See Documentation/SubmittingPatches:
14) The canonical patch format:

The canonical patch message body contains the following:

  - A "from" line specifying the patch author.

  - An empty line.

  - The body of the explanation, which will be copied to the
    permanent changelog to describe this patch.

  - The "Signed-off-by:" lines, described above, which will
    also go in the changelog.

  - A marker line containing simply "---".

  - Any additional comments not suitable for the changelog.

  - The actual patch (diff output).


so just put whatever you want to be in the permanent SCM logs
into the "body of the explanation" part of the email.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

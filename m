Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230Ab0ANFYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0ANFYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483Ab0ANFYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:24:12 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:58623 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0ANFYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:24:11 -0500
Message-ID: <4B4EAA73.5060103@freemail.hu>
Date: Thu, 14 Jan 2010 06:24:03 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Julia Lawall <julia@diku.dk>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Subject: Re: Changelog quality
References: <20100113174446.GA20754@kroah.com> <Pine.LNX.4.44L0.1001131301180.3518-100000@iolanthe.rowland.org> <20100113195226.GD8438@kroah.com>
In-Reply-To: <20100113195226.GD8438@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32711; Body=8 Fuz1=8
	Fuz2=8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Jan 13, 2010 at 01:04:52PM -0500, Alan Stern wrote:
>> On Wed, 13 Jan 2010, Greg KH wrote:
>>
>>>> It would be nice if there was a way to link automatically a git commit
>>>> to an archived copy of the email message in which it was originally 
>>>> submitted.
>>> Ingo has been doing this on some patches by putting a message-id field
>>> in the signed-off-by area showing what lkml message a patch came from.
>>>
>>> See git commit id 6432e734c99ed685e3cad72f7dcae4c65008fcab in Linus's
>>> tree as an example of this.
>>>
>>> I have no objection if people want to do this for any patches going
>>> through my tree as well.
>> If it has to be included manually by the patch submitter then it isn't
>> automatic.  Not to mention that the submitter would need to know the
>> email's message-id before the email message was sent!
>>
>> Something like this should belong in a maintainer's script.
> 
> Yeah, that would get messy, as usually a patch happens in a different
> thread than the original problem occurs, so it would take a lot more
> work on my part to try to match things up.  If I notice it, I will try
> to in the future.

What about introducing a new tag like 'SmPL-Used:'? The used SmPL could
be placed somewhere in the web. This would require only one line in
the changelog: e.g.:

SmPL-Used: http://coccinelle.lip6.fr/sp.php#usb_submit_urb

Usually when an SmPL is created in a general manner it can easily
match 100+ places. These can be combined in groups which for example
belong to one maintainter. That was what I did with adding const to
the different ID tables.

Regards,

	Márton Németh

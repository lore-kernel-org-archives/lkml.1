Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYLNUsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYLNUsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 15:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYLNUsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 15:48:04 -0500
Received: from mx02.qsc.de ([213.148.130.14]:33992 "EHLO mx02.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbYLNUsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 15:48:01 -0500
X-Greylist: delayed 1159 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Dec 2008 15:48:01 EST
Message-ID: <49456C76.20006@wizards.de>
Date: Sun, 14 Dec 2008 21:28:38 +0100
From: =?ISO-8859-1?Q?Holger_Hoffst=E4tte?= <holger@wizards.de>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.27.9
References: <20081214001029.GA915@kroah.com> <pan.2008.12.14.08.06.53.334750@wizards.de> <20081214190829.GA31396@kroah.com>
In-Reply-To: <20081214190829.GA31396@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sun, Dec 14, 2008 at 09:06:53AM +0100, Holger Hoffstaette wrote:
>> On Sat, 13 Dec 2008 16:10:29 -0800, Greg KH wrote:
>>
>>> We (the -stable team) are announcing the release of the 2.6.27.9 kernel.
>> This is still missing the fix for the regression from .7 to .8 that I
>> reported here:
>> http://lkml.indiana.edu/hypermail/linux/kernel/0812.1/00006.html
>>
>> The fix is here:
>> http://lkml.indiana.edu/hypermail/linux/kernel/0812.1/00998.html
>>
>> Been running that on top of -stable and it does fix the problem. It also
>> seems to work for other people. Is there some particular reason why this
>> was not included? I tested and cc'ed stable@ for a reason. :(
> 
> The patch is not in Linus's tree yet, right?  That is a requirement to
> go into the -stable releases.

It is: http://tinyurl.com/5gpqkj

> Also, it is not exactly obvious why a change for idr is needed.  The
> "new" drm code in Fedora releases is understandable, but that is not
> code that is in the main 2.6.27-stable tree, right?

Looking at the log it seems that it fixes a regression introduced by the
previous commit, which seems to affect RCU in general (how or why? no
idea). The Bugzilla bug mentions SysV shared memory and other generic
things, so I'm not the least surprised that samba and apparently other
things as well go bonkers.

That's really all I know.

thanks
Holger


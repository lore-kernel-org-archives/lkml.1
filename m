Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYKVLmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYKVLmD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbYKVLlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:41:53 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33557 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbYKVLlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:41:52 -0500
Message-ID: <4927EFFB.3050707@davidnewall.com>
Date: Sat, 22 Nov 2008 22:11:47 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [take 3] Use pid in inotify events.
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de> <4927B0D5.4020907@davidnewall.com> <20081122094144.GB12543@ioremap.net>
In-Reply-To: <20081122094144.GB12543@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Sat, Nov 22, 2008 at 05:42:21PM +1030, David Newall (davidn@davidnewall.com) wrote:
>   
>> Why not require local access to use the same mechanism as remote, i.e.
>> by "network mounting" the data on the local machine, too.  That way
>> there's no confusion over where the change originated nor who's copy
>> must be invalidated.
>>     
>
> There is always a possibility that some application will access given
> data directly and not via mounted partition

Yes, there will always be ways for motivated users to trip themselves
up.  But that doesn't matter.  You can protect the user, somewhat, using
file permissions on the (outermost) directory containing your files.  If
users break through that and corrupt their data, let them, and let them
learn a lesson.  Don't try to make a foolproof system because: a) it's
likely to be a lot of work for little to no benefit, if indeed it's even
possible; and b) "make a system that even a fool can use and only a fool
will want to," as the aphorism goes.


> plus I have to patch server's kernel with out of the tree modules

Yes, that's the client in a client/server architecture.  Your server is
also a client so it's unremarkable that it would need the client software.

Don't make more work for yourself than necessary.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762360AbXEZSDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762360AbXEZSDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 14:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXEZSD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 14:03:26 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57918
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbXEZSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 14:03:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 20:03:17 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <200705261918.09469.mb@bu3sch.de> <200705261924.33802.uwe.bugla@gmx.de>
In-Reply-To: <200705261924.33802.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262003.17403.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 19:24:33 Uwe Bugla wrote:
> Am Samstag, 26. Mai 2007 19:18 schrieben Sie:
> > On Saturday 26 May 2007 19:04:04 Uwe Bugla wrote:
> > > Yes, sure! But the help text is very unlucky and humble, and it is not
> > > clear enough in the sense of being distinctive enough, just clear and
> > > comprehensive.
> >
> > Why don't you simply submit a patch to change the helptext then?
> > I'm not sure why you refuse to DO anything about the "mess", but
> > instead keep poking me that I am responsible somehow to fix it up
> > for you...
> 
> I need exception examples for doing so. What are the exception examples?
> 
> Apart from that you have don nothing except than guessing around.

Admit it. You don't know how debugging is done in the real world.
Debugging _IS_ guessing around.

> Now here comes the LAST proof that your code is buggy:
> 
> A. It's not mm-implementation
> B. It's not user behaviour or fault
> C. It's not an ACPI issue
> 
> BUT ONE AND ONLY:
> 
> D. It's your code that is buggy, without any doubt!

Blahblah. Did you even read the mail I CCed to you?
It "proves" (to use your wording) the exact opposite.

> OK, went Andrew's path: patched 2.6.22-rc3 with wireless tree:
> 
> Result: The NIC driver b44 and ssb are loaded correctly, but refuse to work
> (no network communication possible).

Ok, please take git and get my development tree and try with that:

git clone http://bu3sch.de/git/wireless-dev.git

It's based on 2.6.22-rc1 and it works fine for me.

> dmesg:
> 
...

Ok, config and dmesg looks OK to me, now.


-- 
Greetings Michael.

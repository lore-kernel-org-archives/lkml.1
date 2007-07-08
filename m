Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbXGHEef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbXGHEef (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 00:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXGHEe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 00:34:29 -0400
Received: from xenotime.net ([66.160.160.81]:52109 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750757AbXGHEe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 00:34:28 -0400
Date: Sat, 7 Jul 2007 21:37:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, davem@davemloft.net
Subject: Re: Coding style on function signatures  (was: Convert tasklets to
 work queues )
Message-Id: <20070707213753.7480ccca.rdunlap@xenotime.net>
In-Reply-To: <46903483.3020205@gmail.com>
References: <20070622182051.859570787@goodmis.org>
	<20070622182315.571740041@goodmis.org>
	<20070623095359.4667514e.akpm@linux-foundation.org>
	<alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
	<20070623115252.fc36f20c.rdunlap@xenotime.net>
	<alpine.LFD.0.98.0706231209130.3593@woody.linux-foundation.org>
	<46903483.3020205@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jul 2007 18:49:07 -0600 Jim Cromie wrote:

> Linus Torvalds wrote:
> >
> >   
> > Yes, code should be less than 80 characters wide. 
> >
> > But hey, sometimes it's just more readable to have one line that is 
> > slightly longer than it should be, than to split something that is awkward 
> > to split. 
> >
> >   
> < cc-list heavily trimmed >
> 
> 
> could you speak to the specific case of function signatures ?
> I saw nothing in CodingStyle specifically about this.
> (I skimmed, and grepped for signature)
> 
> forex:
> 
> static ssize_t
> store_fan_div (struct device *dev, struct device_attribute *devattr,
>                     const char *buf, size_t count)
> {...}
> 
> 
> IIRC, many like the entire sig on one line, because its grep friendly.
> I personally like the above, but grep-ability is hard to argue against.

(I expect that "you" above means Linus, but anyway...)

Some people like the above so that the function name can be grepped
using a "^store_fan_div" regex, but that's not good enough reason
for it for others, including Linus, IIRC.  We have other tools
to find where functions are.

> The above has 2 violations (of strict-grep-ability rule)
> 1 - return sig is separate
> 2 - arg-list is split

#2 can't be helped unless someone is willing to go way beyond the
80-or-so column limit.

I would write that function sig like so:

static ssize_t store_fan_div(struct device *dev,
			struct device_attribute *devattr,
			const char *buf, size_t count)

Some people would add spaces on lines 2 & 3 so that all of the
function parameters are aligned.  I don't care very much one way
or the other about that.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

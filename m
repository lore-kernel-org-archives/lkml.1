Return-Path: <linux-kernel-owner+w=401wt.eu-S1764213AbXILF10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764213AbXILF10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 01:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbXILF1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 01:27:18 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:25910 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbXILF1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 01:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QK4PMg2NYPGcquEVF0IMzdA9IUufyvUg2l64XMPumgvUuQVeTdx/+tW/ulaPDJP/gyYkg9YCOIIOMICwVIHv8K2lWDGZ339NxJ0mhOk8OtzLF/1CK25kqCKWbhxRWA5F1m24XPNhhi+ZvRt6SHtDNgy/RGQbLMz5o8qEBXdXjYA=
Date: Wed, 12 Sep 2007 13:24:13 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
Message-ID: <20070912052413.GH2579@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com> <20070911182926.GQ3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911182926.GQ3563@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 08:29:26PM +0200, Adrian Bunk wrote:
>On Tue, Sep 11, 2007 at 10:16:44AM -0700, Randy Dunlap wrote:
>>...
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +Mutt (TUI)
>> +
>> +Plenty of Linux developers use mutt, so it must work pretty well.
>> +
>> +Are there any special config options that are needed??
>>...
>
>It should work with default settings.


I can't agree with this.

It took me lots of time to configure mutt to work well for me in the first
time. Just default settings are far _not_ enough, especially for us
non-english-speakers. One common setting is the encoding, of course, lkml
prefers UTF-8, so I must set my mutt with `set send_charset="us-ascii:utf-8"`.

Manuals of mutt told me to add "subscribe linux-kernel@vger.kernel.org" if I
subscribed lkml, but in fact, we'd better _not_ add this, or it will drop
myself from cc list.

Or other things like these.

>
>mutt doesn't come with an editor, so whatever editor you use should be 
>used in a way that there are no automatic linebreaks. Most editors have 
>an "insert file" option that inserts the contents of a file unaltered.
>

Yes, you can `set editor="vi"` or other editors you prefer.


Regards.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."


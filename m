Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZIRPhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZIRPhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZIRPhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:37:46 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:32962 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZIRPhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <20090918150541.GB9307@kroah.com>
References: <20090917125759.GA4045@kroah.com> <20090917185306.GA28635@elte.hu> 
	<ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> 
	<alpine.LFD.2.01.0909171322210.4950@localhost.localdomain> 
	<ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com> 
	<alpine.LFD.2.01.0909171709410.4950@localhost.localdomain> 
	<1253238637.4071.10.camel@yio.site> <20090918060210.GC7104@kroah.com> 
	<alpine.LFD.2.01.0909180717380.4950@localhost.localdomain> 
	<20090918150541.GB9307@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 18 Sep 2009 17:37:34 +0200
Message-ID: <ac3eb2510909180837p195704e4y907e6f564acf6efd@mail.gmail.com>
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was: 
	Re: [PATCH] Remove broken by design and by implementation devtmpfs 
	maintenance disaster)
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 17:05, Greg KH <greg@kroah.com> wrote:
> On Fri, Sep 18, 2009 at 07:18:54AM -0700, Linus Torvalds wrote:
>>
>> On Thu, 17 Sep 2009, Greg KH wrote:
>> >
>> > I think the udev version in older Fedora releases can't handle this
>> > kernel option, which is fine, just don't enable it.  Newer versions can
>> > handle it, right?
>>
>> .. conversely, if you can't be bothered to set up /dev/null and /dev/zero
>> correctly, I would suggest that you not set them up AT ALL in devtmpfs.
>
> Fair enough.
>
>> The thing is, 0600 for those nodes is just _wrong_. Don't do it.
>
> Ok, Kay, care to just treat these as "special"?

Sure, the patch I sent yesterday does that. We might want to drop the
USB device node permissions (same as the proc nodes), but they are
probably not needed?

Ingo, do you possibly have a chance to test if your setup comes up
with that? That would be great to know.

Thanks,
Kay

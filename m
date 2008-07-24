Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYGXViO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYGXViO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 17:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYGXVh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 17:37:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:31473 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbYGXVh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 17:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kTdeLC7Ma0PC8JpF30GGDUOYSrY66QL5Gda2NHKkAUvTVTf0/6Tvf7BEFI5DZTSc7Q
         3EszNd5CbgAmxGoWmdgrIScEfq+Viqk0AIfam05sYOAFElL4kN0dgPAcSYZHb3voYn5u
         WStli/+2zw1Jj5jI518MyTfKYDxY0IGxCQFgA=
Message-ID: <5a4c581d0807241437o19b2ad8fha715f7dda5e61119@mail.gmail.com>
Date: Thu, 24 Jul 2008 23:37:57 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: 22bb1be4d27... breaks hal (and NM)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Jean Tourrilhes" <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4888E253.1020401@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.M1pe2GT5+zpRaz/wfP7Zjo6SOMU@ifi.uio.no>
	 <fa.oiNbP36FW/6wru8zoq8SWBE4P+Y@ifi.uio.no>
	 <fa.iZfkeomZo5PN4BBKKgjtHjkkGnw@ifi.uio.no>
	 <fa.cRAFIbCK4bQBxVGv6jJ9s6e4C4M@ifi.uio.no> <4888E253.1020401@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 10:13 PM, Robert Hancock <hancockr@shaw.ca> wrote:
> Andrew Morton wrote:
>>
>> : +config WIRELESS_EXT_SYSFS
>> : +     bool "Wireless extensions sysfs files"
>> : +     default y
>> : +     depends on WIRELESS_EXT && SYSFS
>> : +     help
>> : +       This option enables the deprecated wireless statistics
>> : +       files in /sys/class/net/*/wireless/. The same information
>> : +       is available via the ioctls as well.
>> : +
>> : +       Say Y if you have programs using it (we don't know of any).
>> :
>> So if you've enabled CONFIG_WIRELESS_EXT_SYSFS (and it correctly has
>> default y) then things should continue to work OK.  And the deprecation
>> date of 2010 sounds reasonable.  In fact generous, for us...
>>
>> So where's the problem?
>
> The Kconfig message implies that nobody uses the files. It needs to be
> updated to state that older versions of HAL do use them (and ideally what
> version this was changed).

I was also lured by the Kconfig text, so I changed the default, but
 have noticed no breakage so far.

[asuardi@sandman linux-2.6.26-git11]$ grep WIRELESS_EXT .config
CONFIG_WIRELESS_EXT=y
# CONFIG_WIRELESS_EXT_SYSFS is not set
[asuardi@sandman linux-2.6.26-git11]$ rpm -q hal
hal-0.5.11-2.fc9.i386

Is it because Fedora 9 hal is new enough or because I didn't do anything
 to trigger the breakage ? Just curious.

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')

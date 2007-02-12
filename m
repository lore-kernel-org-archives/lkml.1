Return-Path: <linux-kernel-owner+w=401wt.eu-S964806AbXBLKPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806AbXBLKPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 05:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964812AbXBLKPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 05:15:06 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3749 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964806AbXBLKPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 05:15:04 -0500
X-Greylist: delayed 815 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 05:15:04 EST
From: "Miquel van Smoorenburg" <miquels@cistron.nl>
Subject: Re: [QUESTION] file access time in millisecond?
References: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com> <p73bqjzhhp7.fsf@bingen.suse.de> <b6a2187b0702120152s1279b931x813413a4234d8dec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: mikevs@n2o.xs4all.nl (Miquel van Smoorenburg)
Date: 12 Feb 2007 10:01:24 GMT
Message-ID: <45d03af4$0$326$e4fe514c@news.xs4all.nl>
X-Trace: 1171274484 news.xs4all.nl 326 [::ffff:194.109.0.112]:41236
X-Complaints-To: abuse@xs4all.nl
In-Reply-To: <b6a2187b0702120152s1279b931x813413a4234d8dec@mail.gmail.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <b6a2187b0702120152s1279b931x813413a4234d8dec@mail.gmail.com>,
Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>On 12 Feb 2007 10:02:28 +0100, Andi Kleen <ak@suse.de> wrote:
>
>> > stat() returns time in seconds,
>>
>> Not correct (at least for glibc stat). It supports nanoseconds these days,
>> although not all file systems (including ext3) do yet.
>
>I'm using gcc-3.4.5, and glibc-2.3.6. Don't think 2.3.6 stat() support
>that ... at least the man page doesn't indicate so.

Check out /usr/include/bits/stat.h

My glibc-2.3.2 (debian stable) has the nanoseconds stuff right there,
even though it isn't mentioned in the stat.2 manpage or the info pages.

Mike.

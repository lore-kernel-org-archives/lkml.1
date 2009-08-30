Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZH3LTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZH3LTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 07:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZH3LS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 07:18:59 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:55102 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbZH3LS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 07:18:59 -0400
From: Jim Meyering <jim@meyering.net>
To: Eric Blake <ebb9@byu.net>
Cc: bug-coreutils <bug-coreutils@gnu.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] new open flag O_NOSTD
In-Reply-To: <c5df85930908300412lc2f334dle4502492b25827f5@mail.gmail.com>
	(James Youngman's message of "Sun, 30 Aug 2009 12:12:42 +0100")
References: <4A9285FC.8000606@byu.net>
	<c5df85930908300412lc2f334dle4502492b25827f5@mail.gmail.com>
Date: Sun, 30 Aug 2009 13:18:07 +0200
Message-ID: <87vdk5wnww.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Youngman wrote:
> On Mon, Aug 24, 2009 at 1:22 PM, Eric Blake<ebb9@byu.net> wrote:
>> The name proposed in this mail is O_NOSTD (implying that a successful
>> result will not be any of the standard file descriptors); other ideas
>> mentioned on the bug-gnulib list were O_SAFER, O_NONSTD, O_NOSTDFD.
>> http://lists.gnu.org/archive/html/bug-gnulib/2009-08/msg00358.html
>>
>> Thoughts?
>
> Mostly yes,  I like it.
>
> I'd like to explicitly vote against O_SAFER, because there may be (for
> some systems or in the future) some other way of making open(2) safer.
>   I'd vote positively for O_NOSTDFD or O_NOSTD.

I like this addition, too.
However, I would prefer O_NOSTDFD,
since O_NOSTD evokes "non-standard".

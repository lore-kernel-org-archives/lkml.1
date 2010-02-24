Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab0BXHG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:06:57 -0500
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:65072 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346Ab0BXHG4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:06:56 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 02:06:56 EST
X-AuditID: 12074425-b7bc8ae00000097f-c6-4b84cee2b282
Subject: Re: QUERY: Inclusion of header files in kernel header files
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <22dbbef21002232028i705cee09ic50f30bf830e373@mail.gmail.com>
Date: Wed, 24 Feb 2010 02:02:02 -0500
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0F8F193C-B75C-40CE-9F23-E77953BB67B0@mit.edu>
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com> <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com> <20100223065953.GB32503@liondog.tnic> <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com> <20100223095025.GA18559@liondog.tnic> <22dbbef21002230337i104c63dcm5d59064ca48a07f0@mail.gmail.com> <07BBC9AE-C1A1-449F-AE5E-EB5B1C6323C2@mit.edu> <22dbbef21002232028i705cee09ic50f30bf830e373@mail.gmail.com>
To: viresh kumar <viresh.linux@gmail.com>
X-Mailer: Apple Mail (2.1077)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 23, 2010, at 11:28 PM, viresh kumar wrote:

>> Before someone goes crazy and starts sending hundreds of patches to the trivial patch folks,
>> please make sure that you only do this for places where header file foo uses "struct bar" in
>> bar.h --- and NOT if it is using "struct bar *".    Blind structure pointers don't cause compile
>> failures, and is a perfectly good thing from the standpoint of data hiding.
>> 
> 
> Ted,
> Actually bus.h is using direct instances of these structures and thus
> it is giving compilation warnings.

I'm aware of that --- in this case.   However, this would not be the first time some over-eager kernel programmer newbie finds a message in LKML, reads it out of context, and then starts sending large number of useless, and even potentially harmful patches which all of the kernel maintainers then have to check and NACK.

So while I was pretty sure you knew what you meant, the fact that other people were saying, "Yeah!  Let's sweep through the header files finding all of these potential problems and clean them up," sent a chill down my spine.

													-- Ted


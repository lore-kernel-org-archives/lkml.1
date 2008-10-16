Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYJPSGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYJPSGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYJPSF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:05:58 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:33555 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbYJPSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:05:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18679.33387.696887.282767@stoffel.org>
Date: Thu, 16 Oct 2008 14:05:31 -0400
From: "John Stoffel" <john@stoffel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <20081016153512.GE12962@mit.edu>
References: <20081016002509.GA25868@kroah.com>
	<20081016142619.GA3756@tatooine.rebelbase.local>
	<20081016153512.GE12962@mit.edu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Theodore" == Theodore Tso <tytso@mit.edu> writes:

Theodore> On Thu, Oct 16, 2008 at 04:26:19PM +0200, markus reichelt wrote:
>> Why not just keep it? It has worked so far, and from a strictly
>> end-user point of view I cannot see any advantages at all with a new
>> scheme. The ideas mentioned so far don't cut it either.

Theodore> I'd cast a vote for keeping it as well.  "2.6" is actually a
Theodore> great marker so that people know that it's highly likely the
Theodore> version number is for the Linux kernel.  Contrast "I'm
Theodore> running 2.6.27" versus "I'm running 27" (huh, what does that
Theodore> mean?) or "I'm running the 27 kernel" or "I'm running Linux
Theodore> kernel version 27" or worse yet "I'm running 2008-03".
Theodore> Something like "2.6.27" is just easier to say, and less
Theodore> prone to misunderstanding/confusion.

I dunno... I like the *idea* of a date string, but maybe it needs to
be in parallel and not replace the 2.6.x we have currently?  God knows
a bunch of stuff is going to break when we get to 2.6.100 or 2.>6 or
3.x or whatever.  

But, having something which encodes the release date into the version
string would be useful as well.  On my home debian box I get:

> uname -a
Linux jfsnew 2.6.26 #17 SMP Mon Jul 21 18:58:42 EDT 2008 i686 GNU/Linux

So having "2.6.16 (2008/MM/DD) #17 ..." would be great with me.  But
people would need to think it through more carefully...

John


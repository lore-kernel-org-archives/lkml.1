Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYAGUAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYAGUAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYAGUAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:00:05 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:39056 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYAGUAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:00:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18306.33932.262313.661070@stoffel.org>
Date: Mon, 7 Jan 2008 14:59:08 -0500
From: "John Stoffel" <john@stoffel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: John Stoffel <john@stoffel.org>, Willy Tarreau <w@1wt.eu>,
       Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <478277CF.7070808@s5r6.in-berlin.de>
References: <1199316785.3258.85.camel@localhost.localdomain>
	<alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
	<m3ir27oe7f.fsf@telia.com>
	<1199627875.5205.1.camel@localhost.localdomain>
	<20080106144706.GA25419@elte.hu>
	<1199632845.5205.31.camel@localhost.localdomain>
	<20080106171158.GM20473@parisc-linux.org>
	<1199640983.5205.65.camel@localhost.localdomain>
	<20080106183402.GA7906@1wt.eu>
	<20080106185625.GM2082@does.not.exist>
	<20080106191044.GA1105@1wt.eu>
	<18306.17536.212405.674762@stoffel.org>
	<478277CF.7070808@s5r6.in-berlin.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

Stefan> John Stoffel wrote:
>> The question to me really revolves around how do you automate the
>> process in a transparent manner so that people don't have to change
>> much how they interact with lkml.  

Stefan> I think the more important questions are:
Stefan>   - Are there people who know how to get reports to developers?
Stefan>     (We can't train all potential reporters to get reports right.)

Sure, but telling them "email to helpme@vger.kernel.org" isn't tough.  

Stefan>   - Are there enough developers to work towards bug fixes?

Nope, never enough.

Stefan> The technical means to capture reports, let alone the
Stefan> bugtracking tools, are of secondary importance.

The technical means are secondary, it's the human factors of how bug
reports are captured which is of prime concern.  It's obvious people
aren't happy with bugzilla.  Most, but not all, are happy with LKML,
but a dumb mailing list isn't ideal for tracking bug reports.  

As a SysAdmin, I love being able to tell me user 'just email help' to
open a ticket.  As a SysAdmin, I can then interact with the tickets
which are created and managed using 'RT' (http://www.fsck.org/rt) from
inside my email client without having to think about it too much.  

Again, transparency to the end-user AND tothe developers is key.  If
neither finds if easy to use, it won't be.  So we need to come up with
a work flow which works with us (read you, I just read and contribute
bug reports myself... :-) and for us.  But which never gets in the way
if at all possible.

John



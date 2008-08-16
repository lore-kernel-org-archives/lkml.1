Return-Path: <linux-kernel-owner+w=401wt.eu-S1761394AbYHPEQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394AbYHPEQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 00:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758530AbYHPEJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 00:09:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:34804 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758611AbYHPEJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 00:09:55 -0400
Date: Fri, 15 Aug 2008 21:09:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Peter Dolding" <oiaohm@gmail.com>
Cc: david@lang.hm, rmeijer@xs4all.nl, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, "Eric Paris" <eparis@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>, "Rik van Riel" <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, "Pavel Machek" <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
Message-ID: <20080815210942.4e342c6c@infradead.org>
In-Reply-To: <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
	<e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
	<alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>
	<e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 13:57:50 +1000
"Peter Dolding" <oiaohm@gmail.com> wrote:
> Anti-Virus has been for years about chasing the threat.   Lets try to
> get in front of it.  You thread model needs a major update its
> incomplete.
> 

The problem TALPA is trying to solve is only part of the puzzle.
Everyone recognizes that. It's a very relevant part of the puzzle (in
corporate context at least), but it's very much so not a complete
puzzle. Does that mean we shouldn't deal with this just because it's
incomplete? Absolutely not!
(nor should we do something that has no value.. but that's not the case;
the model that Erik described is quite well defined as 
"do not give ''bad' content to applications/exec".
There is clearly value in that (even though it's not defined what 'bad'
is other than 'program X or Y says so', but for now we have to live
with that; if it bothers you just think "clamAV").

The implementation idea (have a flag/generationnr in the inode for
'known good', block on read() and mmap(), and schedule async scans in
open or on dirty) seems to be quite solid although several details
(async queueing model for example but also the general dirty
notification system) need to be worked out.

Sadly what you're doing is throwing up smoke and just saying "it
doesn't solve world hunger as well so it's bad". Please do yourself a
favor and stop that before people totally start ignoring you.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org


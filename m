Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbXGEOb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbXGEOb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbXGEObs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:31:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61184 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbXGEObq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:31:46 -0400
Date: Thu, 5 Jul 2007 10:23:27 -0400
From: Chris Mason <chris.mason@oracle.com>
To: "John Stoffel" <john@stoffel.org>
Cc: Erik Mouw <mouw@nl.linux.org>, Theodore Tso <tytso@mit.edu>,
       alan <alan@clueserver.org>, J?rn Engel <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070705102327.1863a7d7@think.oraclecorp.com>
In-Reply-To: <18060.63700.223173.537189@stoffel.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org>
	<467314E2.9010306@zytor.com>
	<Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org>
	<20070616145337.GA13391@lazybastard.org>
	<20070618094524.GF5181@schatzie.adilger.int>
	<20070618140143.GD30244@thunk.org>
	<Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org>
	<20070618172955.GB24189@thunk.org>
	<20070704173234.GB26201@gateway.home>
	<18060.63700.223173.537189@stoffel.org>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007 09:57:40 -0400
"John Stoffel" <john@stoffel.org> wrote:

> >>>>> "Erik" == Erik Mouw <mouw@nl.linux.org> writes:
> 
> Erik> (sorry for the late reply, just got back from holiday)
> Erik> On Mon, Jun 18, 2007 at 01:29:56PM -0400, Theodore Tso wrote:
> >> As I mentioned in my Linux.conf.au presentation a year and a half
> >> ago, the main use of Streams in Windows to date has been for system
> >> crackers to hide trojan horse code and rootkits so that system
> >> administrators couldn't find them.  :-)
> 
> Erik> The only valid use of Streams in Windows I've seen was a virus
> Erik> checker that stored a hash of the file in a separate
> Erik> stream. Checking a file was a matter of rehashing it and
> Erik> comparing against the hash stored in the special hash data
> Erik> stream for that particular file.
> 
> So what was stopping a virus from infecting a file, re-computing the
> hash and pushing the new hash into the stream?  
> 
> You need to keep the computed hashes on Read-Only media for true
> security, once you let the system change them, then you're toast....

I'm not a huge fan of streams, but I'm pretty sure there are various
encryption tools that let us verify and validate the source of data.
It's entirely possible the virus checker wasn't doing it right, but
storing verification info in an EA or stream isn't entirely invalid.

You still need an external key that you do trust of course.

-chris
